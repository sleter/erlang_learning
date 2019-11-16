%% Event server
-module(evserv).
-compile(export_all).

-record(state, {events,    %% list of #event{} records
                clients}). %% list of Pids

-record(event, {name="",
                description="",
                pid,
                childs,
                time_to_event,
                timeout={{1970,1,1},{0,0,0}}}).

%%% User Interface

start() ->
    register(?MODULE, Pid=spawn(?MODULE, init, [])),
    Pid.

start_link() ->
    register(?MODULE, Pid=spawn_link(?MODULE, init, [])),
    Pid.

terminate() ->
    ?MODULE ! shutdown.

init() ->
    %% Loading events from a static file could be done here.
    %% You would need to pass an argument to init (maybe change the functions
    %% start/0 and start_link/0 to start/1 and start_link/1) telling where the
    %% resource to find the events is. Then load it from here.
    %% Another option is to just pass the event straight to the server
    %% through this function.
    loop(#state{events=orddict:new(),
                clients=orddict:new()}).

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

add_event(Name, Description, TimeOut) ->
    Ref = make_ref(),
    ?MODULE ! {self(), Ref, {add, Name, Description, TimeOut}},
    receive
        {Ref, {error, Reason}} -> erlang:error(Reason);
        {Ref, Msg} -> Msg
    after 5000 ->
        {error, timeout}
    end.

add_event2(Name, Description, TimeOut, RemainderList) ->
    Ref = make_ref(),
    ?MODULE ! {self(), Ref, {add2, Name, Description, TimeOut, RemainderList}},
    receive
        {Ref, {error, Reason}} -> erlang:error(Reason);
        {Ref, Msg} -> Msg
    after 5000 ->
        {error, timeout}
    end.

cancel(Name) ->
    Ref = make_ref(),
    ?MODULE ! {self(), Ref, {cancel, Name}},
    receive
        {Ref, ok} -> ok
    after 5000 ->
        {error, timeout}
    end.

cancel_with_reminders(Name) ->
    Ref = make_ref(),
    ?MODULE ! {self(), Ref, {cancel_with_reminders, Name}},
    receive
        {Ref, ok} -> ok
    after 5000 ->
        {error, timeout}
    end.

listen(Delay) ->
    receive
        M = {done, _Name, _Description, _TimeToEvent} ->
            [M | listen(0)]
    after Delay*1000 ->
        []
    end.

listen_loop(Delay) -> 
    receive
        {done, Name, Description, TimeToEvent} -> 
            erlang:display("Event name: "++Name),
            erlang:display("Event description: "++Description),
            {Days, {Hour, Minute, Seconds}} = calendar:seconds_to_daystime(TimeToEvent),
            case TimeToEvent > 0 of
                true -> erlang:display("Event starts in: "++integer_to_list(Days)++" days "++integer_to_list(Hour)++" hours "++integer_to_list(Minute)++" minutes and "++integer_to_list(Seconds)++" seconds");
                false -> erlang:display("Event starts now!")
            end,
            listen_loop(Delay)
    after Delay*1000 ->
       io:format("Listening time ended, ")
    end.

events_num()->
    Ref = make_ref(),
    ?MODULE ! {self(), Ref, events_num},
    receive
        {Ref, Num} -> Num
    after 5000 ->
        {error, timeout}
    end.

events_show()->
    Ref = make_ref(),
    ?MODULE ! {self(), Ref, events_show},
    receive
        {Ref, Events} -> Events
    after 5000 ->
        {error, timeout}
    end.

calculate_time_diff(TimeOut={{_,_,_}, {_,_,_}}, RemainderTimeOut={{_,_,_}, {_,_,_}}) ->
    calendar:datetime_to_gregorian_seconds(TimeOut) - calendar:datetime_to_gregorian_seconds(RemainderTimeOut).

%%% The Server itself

loop(S=#state{}) ->
    receive
        {Pid, MsgRef, {subscribe, Client}} ->
            Ref = erlang:monitor(process, Client),
            NewClients = orddict:store(Ref, Client, S#state.clients),
            Pid ! {MsgRef, ok},
            loop(S#state{clients=NewClients});
        {Pid, MsgRef, {add, Name, Description, TimeOut}} ->
            case valid_datetime(TimeOut) of
                true ->
                    EventPid = event:start_link(Name, TimeOut),
                    NewEvents = orddict:store(Name,
                                              #event{name=Name,
                                                     description=Description,
                                                     pid=EventPid,
                                                     childs=0,
                                                     time_to_event=0,
                                                     timeout=TimeOut},
                                              S#state.events),
                    Pid ! {MsgRef, ok},
                    loop(S#state{events=NewEvents});
                false ->
                    Pid ! {MsgRef, {error, bad_timeout}},
                    loop(S)
            end;

        {Pid, MsgRef, {add2, Name, Description, TimeOut, RemainderList}} ->
            %% Check if dates are in proper format
            NotValidDates = lists:foldl(
                fun(Elem, Acc) ->  
                    case valid_datetime(Elem) of
                        false -> Acc ++ [Elem];
                        true -> Acc
                    end
                end,
                [],
                RemainderList++[TimeOut]
            ),
            %% If any of the dates is in wrong format return error
            case length(NotValidDates) /= 0 of
                true ->
                    Pid ! {MsgRef, {error, bad_timeout}},
                    loop(S);
                false ->
                    ok
            end,
            %% Add main event
            Childs = length(RemainderList),
            EventPid = event:start_link(Name, TimeOut),
            NewEventsWithMain = orddict:store(Name,
                                        #event{name=Name,
                                                description=Description,
                                                pid=EventPid,
                                                childs=Childs,
                                                time_to_event=0,
                                                timeout=TimeOut},
                                        S#state.events),
            %% Add remainders
            NewEventsWithRemainders = 
                element(2,
                lists:foldl(
                    fun(Elem, {Number, Events}) ->
                        RName = Name++"_remainder_"++integer_to_list(Number),
                        REventPid = event:start_link(RName, Elem),
                        {Number+1, orddict:store(RName,
                            #event{name=RName,
                            description=Description,
                            pid=REventPid,
                            childs=0,
                            time_to_event=calculate_time_diff(TimeOut, Elem),
                            timeout=Elem},
                            Events)}
                    end,
                    {0, NewEventsWithMain},
                    lists:sort(RemainderList)
                )),
            %% Return back to main loop
            Pid ! {MsgRef, ok},
            loop(S#state{events=NewEventsWithRemainders});

        {Pid, MsgRef, {cancel, Name}} ->
            Events = case orddict:find(Name, S#state.events) of
                         {ok, E} ->
                             event:cancel(E#event.pid),
                             orddict:erase(Name, S#state.events);
                         error ->
                             S#state.events
                     end,
            Pid ! {MsgRef, ok},
            loop(S#state{events=Events});
        {Pid, MsgRef, {cancel_with_reminders, Name}} ->
            Events = case orddict:find(Name, S#state.events) of
                         {ok, E} ->
                             Names = [Name++"_remainder_"++integer_to_list(X) || X <- lists:seq(0,E#event.childs-1)]++[Name],                                                        
                             lists:foldl(
                                 fun(EName, SE) -> 
                                     case orddict:find(EName, SE) of
                                         {ok, EE} ->
                                            event:cancel(EE#event.pid),
                                            orddict:erase(EName, SE);
                                         error ->
                                            S#state.events
                                     end
                                 end,
                                 S#state.events,
                                 Names
                             );
                         error ->
                             S#state.events
                     end,
            Pid ! {MsgRef, ok},
            loop(S#state{events=Events});
        {done, Name} ->
            case orddict:find(Name, S#state.events) of
                {ok, E} ->
                    send_to_clients({done, E#event.name, E#event.description, E#event.time_to_event},
                                    S#state.clients),
                    NewEvents = orddict:erase(Name, S#state.events),
                    loop(S#state{events=NewEvents});
                error ->
                    %% This may happen if we cancel an event and
                    %% it fires at the same time
                    loop(S)
            end;
        {Pid, MsgRef, events_num} ->
            Pid ! {MsgRef, length(S#state.events)},
            loop(S);
        {Pid, MsgRef, events_show} ->
            Pid ! {MsgRef, S#state.events},
            loop(S);
        shutdown ->
            exit(shutdown);
        {'DOWN', Ref, process, _Pid, _Reason} ->
            loop(S#state{clients=orddict:erase(Ref, S#state.clients)});
        code_change ->
            ?MODULE:loop(S);
        {Pid, debug} -> %% used as a hack to let me do some unit testing
            Pid ! S,
            loop(S);
        Unknown ->
            io:format("Unknown message: ~p~n",[Unknown]),
            loop(S)
    end.


%%% Internal Functions
send_to_clients(Msg, ClientDict) ->
    orddict:map(fun(_Ref, Pid) -> Pid ! Msg end, ClientDict).

valid_datetime({Date,Time}) ->
    try
        calendar:valid_date(Date) andalso valid_time(Time)
    catch
        error:function_clause -> %% not in {{Y,M,D},{H,Min,S}} format
            false
    end;
valid_datetime(_) ->
    false.

%% calendar has valid_date, but nothing for days.
%% This function is based on its interface.
%% Ugly, but ugh.
valid_time({H,M,S}) -> valid_time(H,M,S).

valid_time(H,M,S) when H >= 0, H < 24,
                       M >= 0, M < 60,
                       S >= 0, S < 60 -> true;
valid_time(_,_,_) -> false.
