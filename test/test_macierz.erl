-module(test_macierz).
-compile(export_all).

zlicz_wyst(Num, M)->
    lists:foldl(
        fun(L, Acc1)->
            lists:foldl(
                fun(E, Acc2) when E == Num->
                    Acc2+1;
                (_, Acc2)->
                    Acc2
                end,
                Acc1,
                L
            )
        end,
        0,
        M
    ).

map_macierz(F, M)->
    lists:foldl(
        fun(L, Acc1)->
            Acc1++[lists:foldl(
                fun(E, Acc2)->
                    Acc2++[F(E)]
                end,
                [],
                L
            )]
        end,
        [],
        M
    ).

map_macierz2(F,M)->
    [[F(X)||X<-L] || L <- M].

sum_niep(M)->
    lists:foldl(
        fun(L, Acc1)->
            lists:foldl(
                fun(E, Acc2) when E rem 2 == 1->
                    Acc2+E;
                (_, Acc2)->
                    Acc2
                end,
                Acc1,
                L
            )
        end,
        0,
        M
    ).

min(M)->
    [[H|_]|_]=M,
    lists:foldl(
        fun(L, Acc1)->
            lists:foldl(
                fun(E, Acc2) when Acc2 > E->
                    E;
                (_, Acc2)->
                    Acc2
                end,
                Acc1,
                L
            )
        end,
        H,
        M
    ).