-module(test1).
-compile(export_all).


%% only keep even numbers
even(L) -> lists:reverse(even(L,[])).
even([], Acc) -> Acc;
even([H|T], Acc) when H rem 2 == 0 -> even(T, [H|Acc]);
even([_|T], Acc) -> even(T, Acc).
 
%% only keep men older than 60
old_men(L) -> lists:reverse(old_men(L,[])).
old_men([], Acc) -> Acc;
old_men([Person = {Gender, Age}|People], Acc) when Age > 60 andalso Gender == male ->
    old_men(People, [Person|Acc]);
old_men([_|People], Acc) -> old_men(People, Acc).


% filter(fun(X) -> X rem 2 == 0 end, lists:seq(1,10)).
filter(Pred, L) -> lists:reverse(filter(Pred, L,[])).
filter(_, [], Acc) -> Acc;
filter(Pred, [H|T], Acc) ->
    case Pred(H) of
        true  -> filter(Pred, T, [H|Acc]);
        false -> filter(Pred, T, Acc)
    end.

% People = [{male,45},{female,67},{male,66},{female,12},{unknown,174},{male,74}].
% filter(fun({Gender,Age}) -> Gender == male andalso Age > 60 end, People).

% map(F, L)->
%     [F(X) || X<-L].

% map(F, L)->
%     lists:foldl(fun(E, Acc)->Acc++[F(E)] end,[],L).

% test1:foreach(fun(X)->erlang:display(X) end,[1,2,3]). 
foreach(F, L)->
    lists:foldl(fun(E, Acc)->F(E),Acc end,ok,L).

any(Pred, L)->
    lists:foldl(fun(E, Acc)->
        case Pred(E) of
            true -> true;
            false -> Acc
        end 
        end, false, L).


all(Pred, L)->
    lists:foldl(fun(E, Acc)->
        case Pred(E) of
            true -> Acc;
            false -> false
        end
    end,
    true,
    L).

iloczyn_list(L1, L2)->
    lists:foldl(
        fun(E1, Acc)->
            Acc ++ [lists:foldl(
                fun(E2, Acc2)->
                    Acc2 ++ [E1*E2]
                end,
                [],
                L2
            )]
        end,
        [],
        L1
    ).

krotki(Tuples)->
    lists:foldl(
        fun(Tuple, Acc)->
            case element(1,Tuple) == done of
                true->Acc+element(2,Tuple);
                false -> Acc end
        end,
        0,
        Tuples
    ).

% test1:dropwhile(fun(X)->X>3 andalso X<5 end,[1,2,3,4,5,6]).
dropwhile(Pred, L)->
    lists:foldl(
        fun(E,Acc)->
            case Pred(E) of
                true -> Acc;
                false -> Acc++[E]
            end
        end,
        [],
        L
    ).

partition(Pred, L)->
    lists:foldl(
        fun(E, {Left, Right})->
            case Pred(E) of
                true->{Left++[E],Right};
                false->{Left,Right++[E]}
            end
        end,
        {[],[]},
        L
    ).