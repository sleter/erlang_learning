-module(silnia).
-export([m/1, send_pid/2, iterate/2, silnia/1]).

silnia(K)->
    Pids = [spawn(cw3, m, [X]) || X <- lists:seq(1,K)],
    R = iterate(Pids, 1),
    R.

iterate([],Val)->Val;
iterate([Pid|T], Val)->
    R = send_pid(Pid, Val),
    iterate(T,R).

send_pid(Pid, Value) ->
    Pid ! {self(), Value},
    receive
        {Pid, Response} -> Response
    end,
    Pid ! stop,
    Response.

m(X) ->
    receive
        {From, Msg} ->
            From ! {self(), Msg*X},
m(X);
    stop -> true
    end.