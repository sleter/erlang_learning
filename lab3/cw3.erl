-module(cw3).
-export([zad1/0, zad2/0, test/0]).
zad1()->
    % F = fun() -> 2 + 2 end,
    % spawn(F).
    % self().
    processes().

zad2()->
    G = fun(X) -> timer:sleep(1000), io:format("~p~n", [X]) end,
    [spawn(fun() -> G(X) end) || X <- lists:seq(1,10)].

test() ->
    receive M1 when M1>=2 -> io:format("elem: ~p~n", [M1]) end,
    receive M2 when M2=<2 -> io:format("elem: ~p~n", [M2]) end.