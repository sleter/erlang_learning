-module(cw2).
% -compile(export_all).
-export([bar/0, map/2, map_lc/2, foldrC/3, foldrH/3]).

bar() ->
    X=3,
    Add = fun(Y)-> X+Y end,
    Add(10).

%zad2 - base1 = 2 | base2 = 1
%zad3 - "a/0's password is pony"

map(_,[])->[];
map(F,[H|T])->[F(H)|map(F,T)].

% with list comprehensions
% example cw2:map_lc(fun(X) -> 2*X end, [1,2,3]).
map_lc(F,L) ->
    [F(X) || X <- L].

%zad8
%cw2:foldrC(fun(A,B) when A>B -> A; (_,B)->B end, 4, [4,1,2,7,3]).
foldrH(_, Start, [])->Start;
foldrH(F, Start, [H|T])->
    F(H, foldrH(F,Start,T)).

foldrC(F, Accu, [Hd|Tail])->
    F(Hd, foldrC(F,Accu,Tail));
foldrC(F,Accu,[])when is_function(F,2)->Accu.

% zad9
% wybiera max liczbe
% wybiera min liczbe
% zwraca 21 sume wszystkich liczb

