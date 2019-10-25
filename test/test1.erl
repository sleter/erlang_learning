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
% filter(Pred, L) -> lists:reverse(filter(Pred, L,[])).
% filter(_, [], Acc) -> Acc;
% filter(Pred, [H|T], Acc) ->
%     case Pred(H) of
%         true  -> filter(Pred, T, [H|Acc]);
%         false -> filter(Pred, T, Acc)
%     end.

% People = [{male,45},{female,67},{male,66},{female,12},{unknown,174},{male,74}].
% filter(fun({Gender,Age}) -> Gender == male andalso Age > 60 end, People).
