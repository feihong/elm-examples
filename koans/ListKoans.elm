module JsonKoans exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


tests : Test
tests =
    describe "Maybe koans"
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
        ]


main : Runner.TestProgram
main =
    Runner.run tests
