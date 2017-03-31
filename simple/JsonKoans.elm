module MaybeKoans exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner
import Dict
import Json.Decode exposing (..)


tests : Test
tests =
    describe "Json koans"
        [ test "decodeString" <|
            \() ->
                let
                    value =
                        """["monkey", "piano", "sound"]"""
                in
                    decodeString (list string) value
                        |> Expect.equal (Ok [ "monkey", "piano", "sound" ])
        , test "decodeString" <|
            \() ->
                let
                    value =
                        """{"a": 1.2, "b": 2.3, "c": 3.4}"""

                    expectedDict =
                        Dict.fromList [ ( "a", 1.2 ), ( "b", 2.3 ), ( "c", 3.4 ) ]
                in
                    decodeString (dict float) value
                        |> Expect.equal (Ok expectedDict)
        , test "field" <|
            \() ->
                decodeString (field "z" int) """{"z": 888}"""
                    |> Expect.equal (Ok 888)
        , test "at" <|
            \() ->
                let
                    json =
                        """{"member": {"role": "paladin", "name": "Roger", "level": 9001}}"""

                    role =
                        decodeString (at [ "member", "role" ] string) json

                    level =
                        decodeString (at [ "member", "level" ] int) json
                in
                    ( role, level )
                        |> Expect.equal ( Ok "paladin", Ok 9001 )
        ]


main : Runner.TestProgram
main =
    Runner.run tests
