-module(weather_station).
-compile(export_all).

-record(state, {sensor_values,
                clients,
                sensors,
                temperature_values,
                humidity_values,
                ap_values}).

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
    _ = sensor:start_link("temperature_sensor", 10000, 11, "C (Celcius)"),
    _ = sensor:start_link("humidity_sensor", 5000, 2, "RH (relative humidity)"),
    _ = sensor:start_link("atmospheric_pressure_sensor", 11000, 3, "hPa"),
    % start loop
    loop(#state{
        clients=orddict:new(),
        sensors=orddict:new(),
        sensor_values=orddict:new(),
        temperature_values = [],
        humidity_values = [],
        ap_values = []}).

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

get_sensor(SN)->
    Ref = make_ref(),
    ?MODULE ! {self(), Ref, {get_sensor, SN}},
    receive
        {Ref, Msg} -> Msg
    after 5000 ->
        {error, timeout}
    end.

get_saved_sensor_values(SN)->
    Ref = make_ref(),
    ?MODULE ! {self(), Ref, {get_saved_sensor_values, SN}},
    receive
        {Ref, Msg} -> Msg
    after 5000 ->
        {error, timeout}
    end.

eq(A, B) when A =:= B ->
    equal;
eq(_, _) ->
    not_equal.

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
        {Pid, MsgRef, {get_sensor, SN}} ->
            case orddict:find(SN, S#state.sensor_values) of
                {ok, E} ->
                    Pid ! {MsgRef, E},
                    io:format("Server: temperature value send to client:~p .~n", [Pid]),
                    loop(S);
                error ->
                    Pid ! {MsgRef, "Wrong sensor selected"},
                    io:format("Server: wrong sensor (~p) send by client:~p .~n", [SN, Pid]),
                    loop(S)
            end;
        {Pid, MsgRef, {get_saved_sensor_values, SN}} ->

            if
                SN == "temperature" ->
                    Pid ! {MsgRef, S#state.temperature_values},
                    io:format("Server: saved temperature values list send to client:~p .~n", [Pid]);
                SN == "humidity" ->
                    Pid ! {MsgRef, S#state.humidity_values},
                    io:format("Server: saved humidity values list send to client:~p .~n", [Pid]);
                SN == "ap" ->
                    Pid ! {MsgRef, S#state.ap_values},
                    io:format("Server: saved atmospheric pressure values list send to client:~p .~n", [Pid]);
                true ->
                    io:format("Server: wrong sensor (~p) send by client:~p .~n", [SN, Pid]),
                    Pid ! {MsgRef, "Wrong sensor selected"}
            end,
            loop(S);
        {update, Name, Value, Date, U} ->
            io:format("Server: received update from sensor: :~p .~n", [Name]),
            case Name of
                "temperature_sensor" ->
                    Temp = orddict:store("temperature", Value, S#state.sensor_values),
                    Temp2 = orddict:store("temperature_unit", U, Temp),
                    UpdatedValues = orddict:store("temperature_last_update", Date, Temp2);
                "humidity_sensor" ->
                    Temp = orddict:store("humidity", Value, S#state.sensor_values),
                    Temp2 = orddict:store("humidity_unit", U, Temp),
                    UpdatedValues = orddict:store("humidity_last_update", Date, Temp2);
                "atmospheric_pressure_sensor" ->
                    Temp = orddict:store("atmospheric_pressure", Value, S#state.sensor_values),
                    Temp2 = orddict:store("atmospheric_pressure_unit", U, Temp),
                    UpdatedValues = orddict:store("atmospheric_pressure_last_update", Date, Temp2);
                _ ->
                    io:format("No match: ~p~n",[Name]),
                    UpdatedValues = S#state.sensor_values
            end,
            loop(S#state{sensor_values=UpdatedValues});
        {update_with_save, Name, Value, Date, U} ->
            io:format("Server: received update from sensor: :~p .~n", [Name]),
            case Name of
                "temperature_sensor" ->
                    Temp = orddict:store("temperature", Value, S#state.sensor_values),
                    Temp2 = orddict:store("temperature_unit", U, Temp),
                    UpdatedValues = orddict:store("temperature_last_update", Date, Temp2),
                    TVals = lists:append([S#state.temperature_values, [Value]]),
                    loop(S#state{sensor_values=UpdatedValues, temperature_values=TVals});
                "humidity_sensor" ->
                    Temp = orddict:store("humidity", Value, S#state.sensor_values),
                    Temp2 = orddict:store("humidity_unit", U, Temp),
                    UpdatedValues = orddict:store("humidity_last_update", Date, Temp2),
                    HVals = lists:append([S#state.humidity_values, [Value]]),
                    loop(S#state{sensor_values=UpdatedValues, humidity_values=HVals});
                "atmospheric_pressure_sensor" ->
                    Temp = orddict:store("atmospheric_pressure", Value, S#state.sensor_values),
                    Temp2 = orddict:store("atmospheric_pressure_unit", U, Temp),
                    UpdatedValues = orddict:store("atmospheric_pressure_last_update", Date, Temp2),
                    APVals = lists:append([S#state.ap_values, [Value]]),
                    loop(S#state{sensor_values=UpdatedValues, ap_values=APVals});
                _ ->
                    io:format("No match: ~p~n",[Name]),
                    UpdatedValues = S#state.sensor_values,
                    loop(S#state{sensor_values=UpdatedValues})
            end;
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