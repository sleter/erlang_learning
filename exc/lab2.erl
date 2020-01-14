-module(lab2).
-export([main/0]).

main()->
    %s_wstaw([3,1,2]).
    %s_szybkie([3,1,2]).
    %s_wybieranie([3,1,2]).
    map_add({2, cos2}, [{1, cos}]).

s_wstaw([])->[];
s_wstaw([H])->[H];
s_wstaw([H|T])->
    wstaw(H, s_wstaw(T)).

wstaw(E, [])->[E];
wstaw(E, [H|T])when E>H->
    [H|wstaw(E,T)];
wstaw(E, [H|T])when E=<H->
    [E,H|T].

s_szybkie([])->[];
s_szybkie([H])->[H];
s_szybkie([H|T])->
    s_szybkie([ X || X <- T, X<H]) ++
    [H] ++
    s_szybkie([ X || X <- T, X>=H]).


s_wybieranie([])->[];
s_wybieranie(L)-> s_wybieranie(L, []).

s_wybieranie([], L)-> L;
s_wybieranie(L1,L2)->
    Min = lists:min(L1),
    L3 = lists:delete(Min, L1),
    s_wybieranie(L3, L2++[Min]).
    


map_add({}, [])->[];
map_add({Key, Value}, [])->[{Key, Value}];
map_add({Key, Value}, Map)->
    Map ++ [{Key, Value}].



