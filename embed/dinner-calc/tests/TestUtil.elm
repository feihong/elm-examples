module TestUtil exposing (..)

import Test exposing (..)
import Expect
import Util exposing (..)


tests : Test
tests =
    describe "Util tests"
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
        , describe "stringToCents"
            [ test "45.23" <|
                \() ->
                    stringToCents "45.23"
                        |> Expect.equal (Ok 4523)
            , test "102" <|
                \() ->
                    stringToCents "102"
                        |> Expect.equal (Ok 10200)
            , test "34.12a" <|
                \() ->
                    stringToCents "34.12a"
                        |> Expect.equal (Err "Not a valid value for currency")
            ]
        ]
