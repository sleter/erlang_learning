-module(sensor).
-compile(export_all).

-record(state, {server, name="", delay=10000}).

loop(S = #state{server=Server, delay=Delay}) ->
    receive
        {Server, Ref, cancel} -> Server ! {Ref, ok}
    after Delay ->
        Date = erlang:localtime(),
        Value = rand:uniform(10),
        Server ! {update, S#state.name, Value, Date},
        loop(S)
end.

start(Name, Delay) ->
    spawn(?MODULE, init, [self(), Name, Delay]).
 
start_link(Name, Delay) ->
    spawn_link(?MODULE, init, [self(), Name, Delay]).
 
init(Server, Name, Delay) ->
    loop(#state{server=Server,
                name=Name,
                delay=Delay}).

cancel(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, cancel},
    receive
        {Ref, ok} -> erlang:demonitor(Ref, [flush]), ok;
        {'DOWN', Ref, process, Pid, _Reason} -> ok
    end.