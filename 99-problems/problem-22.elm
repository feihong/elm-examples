module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


range : Int -> Int -> List Int
range start end =
    if start == end then
        [ start ]
    else if start > end then
        start :: (range (start - 1) end)
    else
        start :: (range (start + 1) end)


tests : Test
tests =
    describe "range"
        [ test "start == end" <|
            \() ->
                range 1 1
                    |> Expect.equal [ 1 ]
        , test "start < end" <|
            \() ->
                range -4 8
                    |> Expect.equal [ -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8 ]
        , test "start < end" <|
            \() ->
                range 3 4
                    |> Expect.equal [ 3, 4 ]
        , test "start > end" <|
            \() ->
                range 10 2
                    |> Expect.equal [ 10, 9, 8, 7, 6, 5, 4, 3, 2 ]
        , test "start > end" <|
            \() ->
                range 12 11
                    |> Expect.equal [ 12, 11 ]
        , test "Many elements" <|
            \() ->
                range 1 500
                    |> List.length
                    |> Expect.equal 500
        ]


main : Runner.TestProgram
main =
    Runner.run tests
