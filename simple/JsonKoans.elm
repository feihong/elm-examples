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
                    json =
                        """["monkey", "piano", "sound"]"""
                in
                    decodeString (list string) json
                        |> Expect.equal (Ok [ "monkey", "piano", "sound" ])
        , test "decodeString" <|
            \() ->
                let
                    json =
                        """{"a": 1.2, "b": 2.3, "c": 3.4}"""

                    expectedDict =
                        Dict.fromList [ ( "a", 1.2 ), ( "b", 2.3 ), ( "c", 3.4 ) ]
                in
                    decodeString (dict float) json
                        |> Expect.equal (Ok expectedDict)
        , test "field" <|
            \() ->
                let
                    json =
                        """{"x": 1, "y": 2, "z": 888}"""
                in
                    decodeString (field "z" int) json
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
        , test "index" <|
            \() ->
                let
                    json =
                        """[1, 2, 3, 4, 5, 6, 7, 8]"""
                in
                    List.range 0 7
                        |> List.map (\i -> decodeString (index i int) json)
                        |> Expect.equal
                            (List.map Ok [ 1, 2, 3, 4, 5, 6, 7, 8 ])
        , test "oneOf" <|
            \() ->
                let
                    json =
                        """[1,2,null,4]"""

                    badInt =
                        oneOf [ int, null -1 ]
                in
                    decodeString (list badInt) json
                        |> Expect.equal (Ok [ 1, 2, -1, 4 ])
        , test "map" <|
            \() ->
                let
                    json =
                        "\"A112-44Z\""

                    splitId s =
                        case String.split "-" s of
                            a :: b :: _ ->
                                ( a, b )

                            _ ->
                                ( "", "" )
                in
                    decodeString (map splitId string) json
                        |> Expect.equal (Ok ( "A112", "44Z" ))
        ]


main : Runner.TestProgram
main =
    Runner.run tests
