module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


type RleCode a
    = Run Int a
    | Single a


rleDecode : List (RleCode a) -> List a
rleDecode list =
    list
        |> List.concatMap
            (\code ->
                case code of
                    Single x ->
                        [ x ]

                    Run length x ->
                        List.repeat length x
            )



-- rleDecode : List (RleCode a) -> List a
-- rleDecode list =
--     let
--         concat a b =
--             case a of
--                 Single x ->
--                     x :: b
--                 Run length x ->
--                     (List.repeat length x) ++ b
--     in
--         List.foldr concat [] list


tests : Test
tests =
    describe "rleDecode"
        [ test "Empty list" <|
            \() ->
                rleDecode []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                rleDecode [ Single 'a' ]
                    |> Expect.equal [ 'a' ]
        , test "Single element" <|
            \() ->
                rleDecode [ Run 3 'a' ]
                    |> Expect.equal [ 'a', 'a', 'a' ]
        , test "Three elements" <|
            \() ->
                rleDecode [ Run 3 1, Run 2 2, Single 3 ]
                    |> Expect.equal [ 1, 1, 1, 2, 2, 3 ]
        , test "Many elements" <|
            \() ->
                rleDecode [ Run 4 "1", Single "b", Run 2 "5", Single "2", Single "a" ]
                    |> Expect.equal
                        [ "1", "1", "1", "1", "b", "5", "5", "2", "a" ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
