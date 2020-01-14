-module(cw1).
% -compile(export_all).
-export([dopasowanie/2, help_me/1, beach/1, mniejsza/2, wartosc_bezwzgledna/1, trzeci/1]).
-export([fac_r/1, fac_i/1, tail_duplicate/2]).
-export([nalezy_r/2, nalezy_i/2]).
-export([polacz_r/2, polacz_i/2]).
-export([usun_r/2, usun_i/2]).
-export([wstaw_r/2, wstaw_i/2]).
-export([zamien_r/3, zamien_i/3]).
-export([qsort_r/1]).

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

fac_r(N) when N == 0 -> 1;
fac_r(N) when N > 0 -> N*fac_r(N-1).

fac_i(N)->fac_i(N, 1).
fac_i(0, Acc)->Acc;
fac_i(N, Acc)->fac_i(N-1, Acc*N).

tail_duplicate(N,Term) -> tail_duplicate(N,Term,[]).
tail_duplicate(0,_,List) -> List;
tail_duplicate(N,Term,List) when N > 0 -> tail_duplicate(N-1, Term, [Term|List]).


nalezy_r(_, [])->false;
nalezy_r(N, [N | _])->true;
nalezy_r(N, [_ | T])-> nalezy_r(N, T).

nalezy_i(N, List)->nalezy_i(N, List, false).
nalezy_i(_, [], R)->R;
nalezy_i(N, [N | _], _)->nalezy_i(N, [], true);
nalezy_i(N, [H | T], R)when N=/=H->nalezy_i(N, T, R).

polacz_r([],[])->[];
polacz_r([], L)->L;
polacz_r([H|T], L)->[H|polacz_r(T,L)].

polacz_i(L1,L2)->polacz_i(L1,L2,[]).
polacz_i([], [], R)->R;
polacz_i(L1,[_|T],R)->polacz_i(L1,T,R).

usun_r(_, [])->[];
usun_r(E, [H|T]) when E == H ->
    T;
usun_r(E, [H|T]) when E =/= H -> 
    [H | usun_r(E, T)].

usun_i(E,L)->usun_i(E,L,[]).
usun_i(_,[],R)->R;
usun_i(E,[H|T],R) when H==E ->
    usun_i(E,T,R);
usun_i(E,[H|T],R) when H=/=E ->
    usun_i(E,T,R++[H]).

wstaw_r(_,[])->[];
wstaw_r(E, [H|T]) when E < H ->
    [E,H|T];
wstaw_r(E, [H|T])->
    [H|wstaw_r(E,T)].

wstaw_i(E,L)->wstaw_i(E,L,[]).
wstaw_i(_,[],R)->R;
wstaw_i(E, [H|T], R) when E<H ->
    wstaw_i(E, [], R++[E,H|T]);
wstaw_i(E, [H|T], R)->
    wstaw_i(E,T,R++[H]).

zamien_r(_, _, [])->[];
zamien_r(E1, E2, [H|T]) when E1 == H ->
    [E2 | zamien_r(E1, E2, T)];
zamien_r(E1, E2, [H|T]) ->
    [H | zamien_r(E1, E2, T)].

zamien_i(E1,E2,L)->zamien_i(E1,E2,L,[]).
zamien_i(_,_,[],R)->R;
zamien_i(E1,E2,[H|T],R) when E1 == H ->
    zamien_i(E1,E2,T,R++[E2]);
zamien_i(E1,E2,[H|T],R) ->
    zamien_i(E1,E2,T,R++[H]).

qsort_r([])->[];
qsort_r([H])->[H];
qsort_r([H|T])->
    qsort_r([ X || X <- T, X<H]) ++
    [H] ++
    qsort_r([ X || X <- T, X>=H]).