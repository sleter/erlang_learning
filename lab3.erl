-module(lab3).
-export([main/0]).

main()->
    %palindrome("aa").
    %palindrome("abcbaasd").
% -19 + 7x - 4x^2 + 6x^3 //  3 - największa potęga
    %horner([-19,7,-4,6], 3).
    %przed(1,2,[4,1,7,2,9]).
    b([0,1,1,0,1,0,1,1,0,1,0,0,0]).
    %w(3,"+",6,"+",3).

palindrome([])->false;
palindrome([_])->true;
palindrome(A) when length(A)>1 ->
    palindrome(A, 1, length(A) div 2).

palindrome(_, _, 0)->true;
% A - lista, I - indeks kolejnych elementów, N - liczba iteracji
palindrome(A, I, N) ->
    %lists:nth - nty element z listy
    L = lists:nth(I, A),
    R = lists:nth(length(A) - I + 1, A),
    case L == R of
        true ->
            palindrome(A, I + 1, N - 1);
        _ -> false
    end.

przed(_,_,[])->false;
przed(X,Y,L)->
    przed(X,Y,L,0).
przed(_,_,[],0)->false;
przed(X,Y,[H|T],A) when X == H->
    przed(X,Y,T,1);
przed(X,Y,[H|T],A) when Y == H->
    if
        A == 1 ->
            true;
        true ->
            przed(X,Y,T,A)
    end;
przed(X,Y,[H|T],A) when X=/=H orelse Y=/=H->
    przed(X,Y,T,A).

%01(00|10)*11(01|10)+000

b([0,1,1,1|T])->
    b2(T);
b([0,1|T])->
    b1(T);
b(_)->false.

b2([0,1,0,0,0])->
    true;
b2([1,0,0,0,0])->
    true;
b2([1,0|T])->
    b2(T);
b2([0,1|T])->
    b2(T);
b2(_)->false.

b1([0,0,1,1|T])->
    b2(T);
b1([1,0,1,1|T])->
    b2(T);
b1([0,0|T])->
    b1(T);
b1([1,0|T])->
    b1(T);
b1(_)->false.
%01(00|10)*11(01|10)+000

