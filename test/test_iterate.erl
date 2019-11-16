-module(test_iterate).
-compile(export_all).

iterate(S, IsDone, Transform) ->
    C = IsDone(S),
    if 
        C -> S;
        true -> S1 = Transform(S), iterate(S1, IsDone, Transform)
    end.

sqrt(X) ->
    iterate(
        1.0,
        fun(G)-> abs(X-G*G)/X < 0.000001 end,
        fun(G)-> (G+X/G)/2.0 end
    ).

any(Pred, List) ->
    element(1, iterate(
        {false,List}, 
        fun({_, []}) -> true; ({_,[_|_]}) -> false end,
        fun({true, _}) -> {true, []}; ({_, [H|T]}) -> {Pred(H), T} end)
    ).

all(Pred, L) -> 
    element(1, iterate(
        {true, L},
        fun({_, []})->true; ({_, [_|_]})->false end,
        fun({false, _})-> {false, []}; ({_, [H|T]})->{Pred(H), T} end
    )).

filter(Pred, L)->
    element(2, iterate(
        {L, []},
        fun({[_|_],_})->false; ({[],_})->true end,
        fun({[H|T], Out})->
            case Pred(H) of
                true -> {T,Out++[H]};
                false -> {T,Out}
            end
        end)).

mapi(F, L)->
    element(1, iterate(
        {[], L},
        fun({_, []})-> true; ({_, [_|_]})->false end,
        fun({Acc, [H|T]})->
            {Acc++[F(H)], T}
        end
    )).
