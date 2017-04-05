module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


takeWhile : (a -> Bool) -> List a -> List a
takeWhile predicate list =
    case list of
        [] ->
            []

        head :: tail ->
            if predicate head then
                head :: takeWhile predicate tail
            else
                []


isEven x =
    x % 2 == 0


tests : Test
tests =
    describe "takeWhile"
        [ test "Empty" <|
            \() ->
                []
                    |> takeWhile (\_ -> True)
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                [ 10 ]
                    |> takeWhile isEven
                    |> Expect.equal [ 10 ]
        , test "Single element" <|
            \() ->
                [ 11 ]
                    |> takeWhile isEven
                    |> Expect.equal []
        , test "Some elements" <|
            \() ->
                [ 1, 2, 1, 2, 3, 1, 2, 2, 1 ]
                    |> takeWhile (\n -> n <= 2)
                    |> Expect.equal [ 1, 2, 1, 2 ]
        , test "Some elements" <|
            \() ->
                [ 3, 1, 2, 1, 2 ]
                    |> takeWhile (\n -> n <= 2)
                    |> Expect.equal []
        , test "Many" <|
            \() ->
                (List.range 1 1000)
                    |> takeWhile (\n -> n < 500)
                    |> List.length
                    |> Expect.equal 499
        ]


main : Runner.TestProgram
main =
    Runner.run tests
