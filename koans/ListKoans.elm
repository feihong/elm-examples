module ListKoans exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


tests : Test
tests =
    describe "List koans"
        [ test "partition" <|
            \() ->
                let
                    powerLevels =
                        [ 9001, 100, 12000, 2000, 8999, 50000 ]
                in
                    powerLevels
                        |> List.partition (\x -> x > 9000)
                        |> Expect.equal
                            ( [ 9001, 12000, 50000 ], [ 100, 2000, 8999 ] )
        , test "filterMap" <|
            \() ->
                let
                    nums =
                        List.range 1 50
                in
                    nums
                        |> List.filterMap
                            (\x ->
                                if x % 11 == 0 then
                                    Just (negate x)
                                else
                                    Nothing
                            )
                        |> Expect.equal [ -11, -22, -33, -44 ]
        , test "concatMap" <|
            \() ->
                let
                    toChars x =
                        x |> toString |> String.toList
                in
                    List.concatMap toChars [ 12, 45, 789 ]
                        |> Expect.equal [ '1', '2', '4', '5', '7', '8', '9' ]
        , test "indexedMap" <|
            \() ->
                List.indexedMap (\i v -> ( i + 1, v )) [ "cat", "in", "hat" ]
                    |> Expect.equal [ ( 1, "cat" ), ( 2, "in" ), ( 3, "hat" ) ]
        , test "foldl" <|
            \() ->
                let
                    cat newValue accumulator =
                        accumulator ++ "|" ++ newValue
                in
                    List.foldl cat "^" [ "a", "b", "c" ]
                        |> Expect.equal "^|a|b|c"
        , test "foldr" <|
            \() ->
                let
                    cat newValue accumulator =
                        accumulator ++ "|" ++ newValue
                in
                    List.foldr cat "^" [ "a", "b", "c" ]
                        |> Expect.equal "^|c|b|a"
        , test "scanl" <|
            \() ->
                let
                    cat newValue accumulator =
                        accumulator ++ "|" ++ newValue
                in
                    List.scanl cat "^" [ "a", "b", "c" ]
                        |> Expect.equal
                            [ "^", "^|a", "^|a|b", "^|a|b|c" ]
        , test "zip" <|
            \() ->
                let
                    zip list1 list2 =
                        List.map2 (,) list1 list2
                in
                    zip [ 1, 2, 3, 4 ] [ "a", "b", "c", "d" ]
                        |> Expect.equal [ ( 1, "a" ), ( 2, "b" ), ( 3, "c" ), ( 4, "d" ) ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
