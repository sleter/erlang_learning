-module(sensor).
-compile(export_all).

-record(state, {server, name="", delay=10000, save_iteration=5, unit="", actual_iteration=1}).

loop(S = #state{server=Server, delay=Delay, save_iteration=SI, unit=U, actual_iteration=AI}) ->
    receive
        {Server, Ref, cancel} -> Server ! {Ref, ok}
    after Delay ->
        Date = erlang:localtime(),
        Value = rand:uniform(10),
        if SI == AI ->
            Server ! {update_with_save, S#state.name, Value, Date, U},
            loop(S#state{actual_iteration=1});
        true ->
            Server ! {update, S#state.name, Value, Date, U},
            loop(S#state{actual_iteration=AI+1})
        end
    end.

start(Name, Delay, SI, U) ->
    spawn(?MODULE, init, [self(), Name, Delay, SI, U]).
 
start_link(Name, Delay, SI, U) ->
    spawn_link(?MODULE, init, [self(), Name, Delay, SI,U]).
 
init(Server, Name, Delay, SI, U) ->
    loop(#state{server=Server,
                name=Name,
                delay=Delay,
                save_iteration=SI,
                unit=U}).

cancel(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, cancel},
    receive
        {Ref, ok} -> erlang:demonitor(Ref, [flush]), ok;
        {'DOWN', Ref, process, Pid, _Reason} -> ok
    end.