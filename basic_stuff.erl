-module(basic_stuff).
-import(string, [len/1, concat/2, chr/2, substr/3, str/2, to_lower/1, to_upper/1]).
-export([hello_word/0, add/2, add/3, main/0]).

hello_word() -> 
    io:fwrite("Hello Word\n").

add(A,B) ->
    hello_word(),
    A + B.

%c(basic_stuff).
%test -> basic_stuff:add(2,3,4).
add(A,B,C)->
    A+B+C.

main()->
    %var_stuff().
    %do_math(4,5).
    %compare(3,3.0).
    %what_grade(5).
    %say_hello(german).
    %string_stuff().
    %tuple_stuff().
    %list_stuff().
    lc_stuff().

var_stuff()->
    Num = 1,
    Num.

do_math(A,B)->
    A+B,
    A-B,
    A*B,
    %floating point division
    A/B,
    %integer division
    A div B,
    %modulo
    A rem B,
    %e value
    math:exp(1),
    %logarithm
    math:log(2.71),
    math:log10(1000),
    math:pow(2,3),
    math:sqrt(4),
    %other math functions: sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh
    %random value [0, 10]
    random:uniform(10).

compare(A, B)->
    %checks type
    A=:=B,
    A=/=B,
    %type doesnt matter
    A==B.
    % > < >= =< and or not xor

preschool()->
    'Go to preschool'.

kindergarten()->
    'Go to kindergarten'.

school()->
    'Go to school'.

what_grade(A)->
    if A < 5 -> preschool()
    ; A == 5 -> kindergarten()
    ; A > 5 -> school()
    end.

say_hello(A)->
    case A of
        french -> 'Bonjour';
        german -> 'Guten tag';
        english -> 'Hello'
    end.

string_stuff()->
    Str1 = "Random string",
    Str2 = "Another string",
    %display strings
    io:fwrite("String: ~p ~p\n", [Str1, Str2]),
    %display without quotation marks
    Str3 = io_lib:format("~s and ~s\n", [Str1, Str2]),
    io:fwrite(Str3),
    %string length
    len(Str3),
    %add strings
    Str4 = concat(Str1, Str2),
    Str4,
    %index of character | we are looking for 'n'  
    CharIndex = chr(Str4, $n),
    CharIndex,
    %substring of a string
    Str5 = substr(Str4, 6, 6),
    Str5,
    %start index of the substring
    StrIndex = str(Str4, Str2),
    StrIndex,

    to_upper(Str1),
    to_lower(Str1).

tuple_stuff()->
    X = {42, ala, 7.34},
    X,

    {_,_,Out} = X,
    Out,

    X2 = {height, 7.34},
    {height, Ht} = X2,
    Ht.

list_stuff()->
    List1 = [1,2,3],
    List2 = [4,5,6],
    %join lists
    List3 = List1 ++ List2,
    
    List4 = List3 -- List1,
    List4,

    %list head
    hd(List4),
    %list tail
    tl(List4),

    List5 = [3|List4],
    List5,

    [Head|Tail] = List5,
    Head.

lc_stuff()->
    %multiply every element of the list *2
    List1 = [1,2,3],
    List2 = [2*N || N <- List1],
    List2,
    %even values
    List3 = [1,2,3,4],
    List4 = [N || N<- List3, N rem 2 ==0],
    List4,

    CityWeather = [{berlin, 32}, {poznan, 12}, {'new york', -8}],
    GreatTemp = [{City, Temp}||{City,Temp}<-CityWeather, Temp>10],
    GreatTemp.









