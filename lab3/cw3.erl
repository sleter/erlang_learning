-module(cw3).
-export([zad1/0, zad2/0]).

zad1()->
    % F = fun() -> 2 + 2 end,
    % spawn(F).
    % self().
    processes().

zad2()->
    G = fun(X) -> timer:sleep(1000), io:format("~p~n", [X]) end,
    [spawn(fun() -> G(X) end) || X <- lists:seq(1,10)].
