module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


noDupes : List a -> List a
noDupes list =
    let
        noDupeCons x acc =
            case acc of
                [] ->
                    [ x ]

                head :: tail ->
                    if x == head then
                        acc
                    else
                        x :: acc
    in
        List.foldr noDupeCons [] list



-- noDupes : List a -> List a
-- noDupes list =
--     let
--         noDupeCons x acc =
--             case List.head acc of
--                 Nothing ->
--                     [ x ]
--                 Just y ->
--                     if x == y then
--                         acc
--                     else
--                         x :: acc
--     in
--         List.foldr noDupeCons [] list
-- noDupes : List a -> List a
-- noDupes list =
--     case list of
--         [] ->
--             []
--         [ x ] ->
--             [ x ]
--         x :: y :: tail ->
--             if x == y then
--                 noDupes (y :: tail)
--             else
--                 x :: noDupes (y :: tail)


tests : Test
tests =
    describe "noDupes"
        [ test "Empty list" <|
            \() ->
                noDupes []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                noDupes [ 'a' ]
                    |> Expect.equal [ 'a' ]
        , test "Three elements" <|
            \() ->
                noDupes [ 1, 1, 2 ]
                    |> Expect.equal [ 1, 2 ]
        , test "Three elements" <|
            \() ->
                noDupes [ 1, 1, 1 ]
                    |> Expect.equal [ 1 ]
        , test "Three elements" <|
            \() ->
                noDupes [ 1, 2, 1 ]
                    |> Expect.equal [ 1, 2, 1 ]
        , test "Many elements" <|
            \() ->
                noDupes [ 1, 2, 2, 3, 4, 4, 4, 4, 5, 6, 7, 7 ]
                    |> Expect.equal [ 1, 2, 3, 4, 5, 6, 7 ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
