-module(bst).
-compile(export_all).

% Original source
% https://github.com/BartMiki/Learning-Erlang/blob/master/folds/bst.erl?fbclid=IwAR0m4Vxlk1BIrDU1oIrlmX83TROWAuOJZKxUq0xM6MbbUTpEu6M47y_YWBY

run() -> 
    Tree = lists:foldl(fun(E, Acc)->
        tree_add(E, Acc)
    end,
    {},
    [2,1,0,3,-2,9,8,6,-1,7,0]    
    ),

    % iter_tree(Tree).
    % sum_parzyste(Tree).
    wyst_zero(Tree).

tree_add(Elem, {}) -> {Elem, {}, {}};
tree_add(Elem, {Value, Left, Right}) when Elem < Value ->
    {Value, tree_add(Elem, Left), Right};
tree_add(Elem, {Value, Left, Right}) when Elem >= Value ->
    {Value, Left, tree_add(Elem, Right)}.

iter_tree({}) -> [];
iter_tree({Value, Left, Right}) ->
    iter_tree(Left)++[Value]++iter_tree(Right).

foldl_(F, Start, Tree)->
    lists:foldl(F, Start, iter_tree(Tree)).

sum_parzyste(Tree)->
    lists:foldl(
        fun(E, Acc)->
            if E < 0 andalso E rem 2 == 0 -> Acc+(E*-1);
            E >= 0 andalso E rem 2 == 0 -> Acc+E;
            true -> Acc
            end
        end,
        0,
        iter_tree(Tree)
    ).

wyst_zero(Tree)->
    foldl_(
        fun(E, Acc) when E == 0 ->
            Acc+1;
        (_, Acc) -> 
            Acc
        end,
        0,
        Tree
    ).