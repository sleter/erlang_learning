-module(basic_stuff2).
-export([main/0]).

main()->
    %type_stuff().
    %find_factorial(3).
    %sum([1,2,3]).
    %sum2([1,2,3], 0).
    %%----for(maxValue, startValue)
    %for(3,1).
    %map_stuff().
    %record_stuff().
    %do_math().
    %fun_stuff("Szymon").
    %fun_stuff2().
    

type_stuff()->
    is_atom(name),
    is_float(3.14),
    is_integer(3),
    is_boolean(false),
    is_list([1,2,3]),
    is_tuple({height, 180}),

    %you can convert types:
    % type_to_type !
    %example: integer_to_list

    List1 = integer_to_list(21),
    List1.

factorial(A) when A == 0 -> 1;
factorial(A) when A > 0 -> A*factorial(A-1).

find_factorial(A)->
    B = factorial(A),
    io:fwrite("Factorial: ~p\n", [B]).

sum([]) -> 0;
sum([H|T]) -> H+ sum(T).

sum2([], Sum) -> Sum;
sum2([H|T], Sum)->
    io:fwrite("Sum: ~p\n", [Sum]),
    sum2(T, H+Sum).

for(0, _)->ok;
for(Max,Min) when Max > 0->
    io:fwrite("Num: ~p\n",[Max]),
    for(Max-1, Min).

map_stuff()->
    Bob = #{f_name=> 'Bob', l_name=> 'Smith'},

    io:fwrite("f_name: ~p\n", [maps:get(f_name, Bob)]),
    io:fwrite("~p\n", [maps:keys(Bob)]),
    io:fwrite("~p\n", [maps:values(Bob)]),
    io:fwrite("~p\n", [maps:remove(l_name, Bob)]),
    maps:find(f_name, Bob),
    maps:put(address, "123 street", Bob).

-record(customer, {name = "", bal = 0.00}).

record_stuff()->
    Sally = #customer{name="Sally Smith", bal = 100.00},

    Sally2 = Sally#customer{bal = 50},

    io:fwrite("~p owes $ ~p\n", [Sally2#customer.name, Sally2#customer.bal]).

double(X)-> X*2.
triple(X)-> X*3.

do_math()->
    lists:map(fun double/1, [1,2,3]),
    lists:map(fun triple/1, [1,2,3]).


fun_stuff(X)->
    Fun_Stuff = fun() -> io:fwrite("Hello ~p\n", [X]) end,
    Fun_Stuff().

fun_stuff2()->
    X=3,
    Y=4,
    Z = fun()->
        io:fwrite("Sum: ~p\n", [X+Y]) end,
    Z().


