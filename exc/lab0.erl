-module(lab0).
-export([razy_3/1]).
-export([mniejsza/2]).
-export([absolut/2]).

razy_3(N)->3*N.

mniejsza(A, B) when A=<B -> A;
mniejsza(A, B) when B<A -> B.

absolut(N) when N=<0 -> -1*N;
absolut(N) _ -> N.
