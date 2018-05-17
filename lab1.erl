-module(lab1).
-export([zad1/0, zad2/0, zad3/0]).

zad1()->
    %silnia(4),
    %parzyste(26),
    %fib(6),
    isilnia(5).

silnia(1)->1;
silnia(N)->N*silnia(N-1).

isilnia(N)->isilnia(N,1,1).
isilnia(0,R,_)->R*2;
isilnia(I,R,X)->isilnia(I-1,R*X,R+1).

parzyste(N) when N rem 2 == 0 -> io:fwrite("~p jest parzyste\n",[N]);
parzyste(N) when N rem 2 =/= 0 -> io:fwrite("~p jest nieparzyste\n",[N]).

fib(0)->0;
fib(1)->1;
fib(N)->
    fib(N-1)+fib(N-2).

ifib(N) -> ifib(N, 0, 1).
ifib(0, R, _) -> R;
ifib(I, R, X) -> ifib(I-1, X, R+X).

zad2()->
    member(8,[1,2,3]),
    polacz([1,2,3],[4,5,6]).
    %dlugosc([1,2,4,9,1]).

member(_,[])->not_found;
member(H,[H|_])->found;
member(E, [_|T])->
    member(E, T).

polacz([],[])->[];
polacz([],L)->L;
polacz([H|T],L)->
    [H|polacz(T,L)].

dlugosc([])->0;
dlugosc(N)->dlugosc(N, 0).

dlugosc([_|T], C)->
    dlugosc(T, C+1);
dlugosc([],C)->C.


zad3()->
    suma([1,2,3]),
    zmniej_o_n([1,2,3],1),
    zzero([0,1,0,2,3]),
    hum([1,8,3,7,2]).

suma(L)->suma(L,0).
suma([H|T],A)->
    suma(T,H+A);
suma([],A)->A.

zmniej_o_n(L,I)->zmniej_o_n(L,I,[]).
zmniej_o_n([H|T],I,Out)->
    P=H-I,
    zmniej_o_n(T,I,lists:append(Out,[P]));
zmniej_o_n([],_,L)->L.


%0 na koniec
zero(L)->zero(L,[],[]).
zero([H|T],L,L1) when H==0->
    zero(T,lists:append(L,[H]), L1);
zero([H|T],L,L1) when H=/=0->
    zero(T,L, lists:append(L1,[H]));
zero([],L,L1)->
    lists:append(L1,L).

zzero([])->[];
zzero([H|T])->
    case H==0 of
        true -> zzero(T)++[0];
        false -> [H|zzero(T)]
    end.

hum(L)->hum(L,0).
hum([H|T],I) when (H>1) and (H<5)->
    hum(T,I+1);
hum([],I)->
    I.











