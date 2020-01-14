-module(weather_station).
-compile(export_all).

-record(state, {sensor_values,
                clients,
                sensors}).

start() ->
    register(?MODULE, Pid=spawn(?MODULE, init, [])),
    Pid.

start_link() ->
    register(?MODULE, Pid=spawn_link(?MODULE, init, [])),
    Pid.

terminate() ->
    ?MODULE ! shutdown.

init() ->
    % start sensors
    _ = sensor:start_link("temperature_sensor", 10000),
    _ = sensor:start_link("humidity_sensor", 5000),
    _ = sensor:start_link("atmospheric_pressure_sensor", 11000),
    % start loop
    loop(#state{
        clients=orddict:new(),
        sensors=orddict:new(),
        sensor_values=orddict:new()}).

subscribe(Pid) ->
    Ref = erlang:monitor(process, whereis(?MODULE)),
    ?MODULE ! {self(), Ref, {subscribe, Pid}},
    receive
        {Ref, ok} ->
            {ok, Ref};
        {'DOWN', Ref, process, _Pid, Reason} ->
            {error, Reason}
    after 5000 ->
        {error, timeout}
    end.

get_info() ->
    Ref = make_ref(),
    ?MODULE ! {self(), Ref, {get_info}},
    receive
        {Ref, Msg} -> Msg
    after 5000 ->
        {error, timeout}
    end.

loop(S=#state{}) ->
    receive
        {Pid, MsgRef, {subscribe, Client}} ->
            Ref = erlang:monitor(process, Client),
            NewClients = orddict:store(Ref, Client, S#state.clients),
            Pid ! {MsgRef, ok},
            loop(S#state{clients=NewClients});
        {Pid, MsgRef, {get_info}} ->
            Pid ! {MsgRef, orddict:to_list(S#state.sensor_values)},
            io:format("Server: sensor values send to client:~p .~n", [Pid]),
            loop(S);
        {update, Name, Value, Date} ->
            io:format("Server: received update from sensor: :~p .~n", [Name]),
            case Name of
                "temperature_sensor" ->
                    Temp = orddict:store("temperature", Value, S#state.sensor_values),
                    UpdatedValues = orddict:store("temperature_last_update", Date, Temp);
                "humidity_sensor" ->
                    Temp = orddict:store("humidity", Value, S#state.sensor_values),
                    UpdatedValues = orddict:store("humidity_last_update", Date, Temp);
                "atmospheric_pressure_sensor" ->
                    Temp = orddict:store("atmospheric_pressure", Value, S#state.sensor_values),
                    UpdatedValues = orddict:store("atmospheric_pressure_last_update", Date, Temp);
                _ ->
                    io:format("No match: ~p~n",[Name]),
                    UpdatedValues = S#state.sensor_values
            end,
            loop(S#state{sensor_values=UpdatedValues});
        shutdown ->
            exit(shutdown);
        {'DOWN', Ref, process, _Pid, _Reason} ->
            loop(S#state{clients=orddict:erase(Ref, S#state.clients)});
        code_change ->
            ?MODULE:loop(S);
        {Pid, debug} ->
            Pid ! S,
            loop(S);
        Unknown ->
            io:format("Unknown message: ~p~n",[Unknown]),
            loop(S)
    end.