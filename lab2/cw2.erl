-module(cw2).
% -export([bar/0, map/2, map_lc/2, foldrC/3, foldrH/3, iterate/3, examp_while/1]).
% -export([usun/2,zamien/3]).
-compile(export_all).

bar() ->
    X=3,
    Add = fun(Y)-> X+Y end,
    Add(10).

%zad2 - base1 = error | base2 = 1
%zad3 - "a/0's password is pony"

map(_,[])->[];
map(F,[H|T])->[F(H)|map(F,T)].

% with list comprehensions
% example cw2:map_lc(fun(X) -> 2*X end, [1,2,3]).
map_lc(F,L) ->
    [F(X) || X <- L].

%zad8
% cw2:foldrC(fun(A,B) when A>B -> A; (_,B)->B end, 4, [4,1,2,7,3]).
foldrH(_, Start, [])->Start;
foldrH(F, Start, [H|T])->F(H, foldrH(F,Start,T)).

foldrC(F, Accu, [Hd|Tail])->
    F(Hd, foldrC(F,Accu++[Hd],Tail));
foldrC(F,Accu,[])when is_function(F,2)->Accu.

% zad9
% wybiera max liczbe
% wybiera min liczbe
% zwraca 21 sume wszystkich liczb

% zad10
% potega -> lists:foldl(fun(A,B) -> A*B end, 1, [2,3,4,5]).

iterate(S, IsDone, Transform) ->
 %IsDone i Transform są jednoargumentowe
    C = IsDone(S),
    if C -> S;
        true -> S1 = Transform(S), iterate(S1, IsDone, Transform)
    end.

examp_while(X)->
    iterate(5,fun(G) -> X, X<G end,fun(_) -> X*2 end).

zamien(From,To,L)->
    lists:foldl(fun(E,A) when E==From -> A++[To]; (E,A)->A++[E] end, [], L).

usun(Elem,L)->
    lists:foldl(fun(E,A) when E==Elem -> A; (E,A)->A++[E] end, [], L).

wstaw(Elem, L) ->
    lists:reverse(lists:foldl(fun(E, Acc=[AccH|_]) when Elem=<E andalso Elem>AccH -> [E, Elem|Acc]; (E, Acc) -> [E|Acc] end, [], L)).