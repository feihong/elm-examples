module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner
import Random


lotto : Random.Seed -> Int -> Int -> Int -> List Int
lotto seed n low high =
    let
        intGenerator =
            Random.int low high

        -- Add a random integer to the accumulator
        addValue _ ( values, previousSeed ) =
            let
                ( newValue, newSeed ) =
                    Random.step intGenerator previousSeed
            in
                ( newValue :: values, newSeed )
    in
        List.range 1 n
            |> List.foldl addValue ( [], seed )
            |> Tuple.first


seed : Random.Seed
seed =
    Random.initialSeed 1


tests : Test
tests =
    describe "lotto"
        [ test "8 to 8" <|
            \() ->
                lotto seed 5 8 8
                    |> Expect.equal [ 8, 8, 8, 8, 8 ]
        , test "1 to 2" <|
            \() ->
                lotto seed 5 1 2
                    |> Expect.equal [ 1, 2, 2, 1, 2 ]
        , test "1 to 10" <|
            \() ->
                lotto seed 5 1 10
                    |> Expect.equal [ 1, 10, 8, 9, 8 ]
        , test "1 to 10000" <|
            \() ->
                lotto seed 5 1 10000
                    |> Expect.equal [ 1221, 3130, 8828, 5089, 2898 ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
