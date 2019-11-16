-module(kolos).
-compile(export_all).

any(Pred, L)->
    lists:foldl(fun({_, Value}, Acc)->
        case Pred(Value) of
            true -> true;
            false -> Acc
        end 
        end, false, L).


run() -> 
    DAG = lists:foldl(fun(E, Acc)->
        ad_add(E, Acc)
    end,
    {[], []},
    [{1,3, []}, {2,4, [3]}, {3,6, [1]}, {4,1,[2,3]}]    
    ),
    dag_foldl(
        fun(E, Acc) when E rem 4 == 0 ->
            Acc+1;
        (_, Acc)->
            Acc
        end,
        0,
        DAG
    ).


% dag_add(Elem, {}) -> {Elem, {}, {}};
% dag_add({NewKey, Elem}, {Key, Value, Left, Right}) when NewKey < Key ->
%     {Key, Value, dag_add({NewKey, Elem}, Left), Right};
% dag_add({NewKey, Elem}, {Key, Value, Left, Right}) when NewKey >= Key ->
%     {Key, Value, Left, dag_add({NewKey, Elem}, Right)}.

ad_add({Key, Value, []}, {[], []})->
    {[{Key, Value}], []};
ad_add({Key, Value, NewConnections}, {Keys, Connections})->
    {Keys++[{Key, Value}], Connections++[{Key, NewConnections}]}.

count(DAG)->
    DagKeysValues = element(
        1, DAG
    ),
    lists:foldl(
        fun({_, Value}, Acc) when Value rem 4 == 0 ->
            Acc+1;
        (_, Acc)->
            Acc
        end,
        0,
        DagKeysValues
    ).

get_vals(DagKeysValues)->
    lists:foldl(
        fun({_, Val}, Acc)->
            Acc++[Val]
        end,
        [],
        DagKeysValues
    ).


dag_foldl(F, Start, DAG)->
    DagKeysValues = element(1, DAG),

    lists:foldl(
        F, Start, DagKeysValues).



iter_dag({}) -> [{}];
iter_dag({Key, Value, Left, Right}) ->
    iter_dag(Left)++[{Key, Value}]++iter_dag(Right).
