-module(cw1).
% -compile(export_all).
-export([dopasowanie/2, help_me/1, beach/1, mniejsza/2, wartosc_bezwzgledna/1, trzeci/1]).
-export([fac/1, tail_duplicate/2]).
-export([nalezy_r/2]).


dopasowanie(A, B) ->
    R = if A =:= B -> false;
    A == B -> true
    end,
    R.

help_me(Animal) ->
    Talk = if Animal == cat -> "meow";
        Animal == beef -> "mooo";
        Animal == dog -> "bark";
        Animal == tree -> "bark";
        true -> "fgdadfgna"
    end,
    {Animal, "says " ++ Talk ++ "!"}.


beach(Temperature) ->
    case Temperature of
        {celsius, N} when N >= 20, N =< 45 ->
            'favorable';
        {kelvin, N} when N >= 293, N =< 318 ->
            'scientifically favorable';
        {fahrenheit, N} when N >= 68, N =< 113 ->
            'favorable in the US';
        _ ->
            'avoid beach'
    end.

mniejsza(A, B) ->
    M = if A=<B -> A;
        A>B -> B
    end,
    M.

wartosc_bezwzgledna(A) when A < 0 -> A*-1;
wartosc_bezwzgledna(A) -> A.

trzeci(A) ->
    [_,_,X | _] = A,
    X.

fac(N) when N == 0 -> 1;
fac(N) when N > 0 -> N*fac(N-1).

tail_duplicate(N,Term) -> tail_duplicate(N,Term,[]).
tail_duplicate(0,_,List) -> List;
tail_duplicate(N,Term,List) when N > 0 -> tail_duplicate(N-1, Term, [Term|List]).


nalezy_r(N, Lista) when [N | _] = Lista -> true;
nalezy_r(N, []) -> false; 
nalezy_r(N, Lista) when [X | Tail] = Lista -> nalezy_r(N, Tail).
