module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner
import Random


randomSelect : Random.Seed -> Int -> List a -> ( List a, Random.Seed )
randomSelect seed n list =
    let
        elementAt index list =
            list |> List.drop index |> List.head

        intGenerator =
            Random.int 0 ((List.length list) - 1)

        -- Add a random element of the list to the accumulator
        addValue _ ( values, previousSeed ) =
            let
                ( index, newSeed ) =
                    Random.step intGenerator previousSeed
            in
                case elementAt index list of
                    Just newValue ->
                        ( newValue :: values, newSeed )

                    Nothing ->
                        ( values, newSeed )
    in
        List.range 1 n
            |> List.foldl addValue ( [], seed )


seed : Random.Seed
seed =
    Random.initialSeed 1


tests : Test
tests =
    describe "randomSelect"
        [ test "Empty list" <|
            \() ->
                randomSelect seed 3 []
                    |> Tuple.first
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                randomSelect seed 5 [ 'a' ]
                    |> Tuple.first
                    |> Expect.equal [ 'a', 'a', 'a', 'a', 'a' ]
        , test "Two elements" <|
            \() ->
                randomSelect seed 5 [ 'a', 'b' ]
                    |> Tuple.first
                    |> Expect.equal [ 'a', 'b', 'b', 'a', 'b' ]
        , test "Many elements" <|
            \() ->
                randomSelect seed 5 (List.range 1 1000)
                    |> Tuple.first
                    |> Expect.equal [ 221, 130, 828, 89, 898 ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
