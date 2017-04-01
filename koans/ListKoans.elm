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
        ]


main : Runner.TestProgram
main =
    Runner.run tests
