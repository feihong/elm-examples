module TestHelpers exposing (..)

import Test exposing (..)
import Expect
import Test.Runner.Html as Runner
import Helpers exposing (..)


tests : Test
tests =
    describe "Helper tests"
        [ describe "centsToString"
            [ test "0" <|
                \() ->
                    centsToString 0
                        |> Expect.equal "0.00"
            , test "300" <|
                \() ->
                    centsToString 300
                        |> Expect.equal "3.00"
            , test "503" <|
                \() ->
                    centsToString 503
                        |> Expect.equal "5.03"
            , test "1136" <|
                \() ->
                    centsToString 1136
                        |> Expect.equal "11.36"
            ]
        ]
