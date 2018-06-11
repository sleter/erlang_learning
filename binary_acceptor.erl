%01(00|10)*11(01|10)+000

a([0,1,1,1|T])->a2(T);
a([0,1,0,0|T])->a1(T);
a([0,1,1,0|T])->a1(T);
a(_)->false.

a1([0,0,1,1|T])->a2(T);
a1([1,0,1,1|T])->a2(T);
a1([0,0|T])->a1(T);
a1([1,0|T])->a1(T);
a1(_)->false.

a2([0,1,0,0,0])->true;
a2([1,0,0,0,0])->true;
a2([0,1|T])->a2(T);
a2([1,0|T])->a2(T);
a2(_)->false.

czy_rowne([H1|T1],[H2|T2]) when H1==H2 ->
czy_rowne(T1,T2);
czy_rowne([H1|T1],[H2|T2]) when H1=/=H2 ->
false;
czy_rowne([],[])->true;
czy_rowne([],[_])->false;
czy_rowne([_],[])->false.

indeks(E, L)->indeks(E, L, 0).
indeks(E, [], _)->false;
indeks(E, [E|T], I)->I;
indeks(E, [_|T], I)->
indeks(E, T, I+1).

usun(E, L)->usun(E, L, []).
usun(_, [], L)->L;
usun(E, [E|T], L)->
usun(E, T, L);
usun(E, [H|T], L)->
usun(E, T, L++[H]).

jest([H|T1], [H|T2])-> jest(T1,T2); 
jest([H1|T1], [H2|T2])->jest([H1|T1],T2); 
jest([_|_],[])->false; 
jest([],[])->true; 
jest([],[_|_])->true.
















