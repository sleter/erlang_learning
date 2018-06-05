-module(onp).
-export([onp/1]).

dzialaj([],Liczby) -> hd(Liczby);

dzialaj(["+"| T ],Liczby) -> 
    [A | B] = Liczby,

	Stos = [ A + hd(B) | tl(B)],
	dzialaj(T,Stos);
	
dzialaj(["-"| T ],Liczby) -> 
	[A | B] = Liczby,
	Stos = [ A - hd(B) | tl(B)],
	dzialaj(T,Stos);
	
dzialaj(["*"| T ],Liczby) -> 
	[A | B] = Liczby,
	Stos = [ A*hd(B) | tl(B)],
	dzialaj(T,Stos);
	
dzialaj(["/"| T ],Liczby) -> 
	[A | B] = Liczby,
	Stos = [ A/hd(B) | tl(B)],
	dzialaj(T,Stos);

dzialaj(["sqrt"| T ],Liczby) -> 
	[A | B] = Liczby,
	Stos = [ math:sqrt(A) | B],
	dzialaj(T,Stos);
	
dzialaj(["sin"| T ],Liczby) -> 
	[A | B] = Liczby,
	Stos = [ math:sin(A) | B],
	dzialaj(T,Stos);
	
dzialaj(["cos"| T ],Liczby) -> 
	[A | B] = Liczby,
	Stos = [ math:cos(A) | B],
	dzialaj(T,Stos);
	
dzialaj(["^"| T ],Liczby) -> 
	[A | B] = Liczby,
	Stos = [ math:pow(A,hd(B)) | tl(B)],
	dzialaj(T,Stos);
	
dzialaj([H | T],Stos) -> 
	{A,_} = string:to_float(H),
	Liczby = [A | Stos],
	dzialaj(T,Liczby).
	
onp([]) -> io:format("Koniec ~n");
onp(Wyrazenie) -> 
		Lista = string:tokens(Wyrazenie," "),
		dzialaj(Lista,[]).