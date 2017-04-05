module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


dropWhile : (a -> Bool) -> List a -> List a
dropWhile fn list =
    case list of
        [] ->
            []

        head :: tail ->
            if fn head then
                dropWhile fn tail
            else
                list


isEven x =
    x % 2 == 0


tests : Test
tests =
    describe "dropWhile"
        [ test "Empty" <|
            \() ->
                []
                    |> dropWhile (\_ -> True)
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                [ 10 ]
                    |> dropWhile isEven
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                [ 11 ]
                    |> dropWhile isEven
                    |> Expect.equal [ 11 ]
        , test "Three elements" <|
            \() ->
                [ 1, 2, 1, 2, 3, 1, 2, 2, 1 ]
                    |> dropWhile (\n -> n <= 2)
                    |> Expect.equal [ 3, 1, 2, 2, 1 ]
        , test "Many" <|
            \() ->
                (List.range 1 1000)
                    ++ (List.range 1 400)
                    |> dropWhile (\n -> n < 500)
                    |> List.length
                    |> Expect.equal 901
        ]


main : Runner.TestProgram
main =
    Runner.run tests
