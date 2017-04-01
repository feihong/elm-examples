module JsonKoans exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner
import Dict
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias BoundingBox =
    { x : Int, y : Int, width : Int, height : Int }


type alias Patient =
    { fullName : String, phobia : String }


createPatientFromVersion1 first last fear =
    let
        fearMap =
            Dict.fromList
                [ ( "spiders", "arachno" )
                , ( "tight spaces", "claustro" )
                , ( "heights", "acro" )
                ]
    in
        { fullName = first ++ " " ++ last
        , phobia =
            case Dict.get fear fearMap of
                Nothing ->
                    "nonclinical: " ++ fear

                Just name ->
                    name
        }


decoder1 =
    decode createPatientFromVersion1
        |> required "first_name" string
        |> required "last_name" string
        |> required "fear" string


decoder2 =
    decode Patient
        |> required "fullName" string
        |> required "phobia" string


patientDecoder =
    field "version" int
        |> andThen
            (\version ->
                case version of
                    1 ->
                        decoder1

                    2 ->
                        decoder2

                    _ ->
                        fail <| "Unsupported version: " ++ (toString version)
            )


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
        , test "nullable" <|
            \() ->
                let
                    badInt =
                        (nullable int)
                in
                    [ "4", "null" ]
                        |> List.map (\str -> decodeString badInt str)
                        |> Expect.equal [ Ok (Just 4), Ok Nothing ]
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
        , test "map4" <|
            \() ->
                let
                    json =
                        """{"x": 110, "y": 320, "w": 50, "h": 75}"""

                    decoder =
                        map4 BoundingBox
                            (field "x" int)
                            (field "y" int)
                            (field "w" int)
                            (field "h" int)
                in
                    decodeString decoder json
                        |> Expect.equal
                            (Ok { x = 110, y = 320, width = 50, height = 75 })
        , test "andThen" <|
            \() ->
                let
                    json =
                        """{"version": 1,
                        "first_name": "Billy",
                        "last_name": "Poe",
                        "fear": "spiders"}"""
                in
                    decodeString patientDecoder json
                        |> Expect.equal (Ok { fullName = "Billy Poe", phobia = "arachno" })
        , test "andThen" <|
            \() ->
                let
                    json =
                        """{"version": 2,
                            "fullName": "Crabby Pants",
                            "phobia": "acro"}"""
                in
                    decodeString patientDecoder json
                        |> Expect.equal
                            (Ok { fullName = "Crabby Pants", phobia = "acro" })
        , test "andThen" <|
            \() ->
                let
                    json =
                        """{"version": 3,
                            "fullName": "Crabby Pants",
                            "phobia": "acro"}"""
                in
                    decodeString patientDecoder json
                        |> Expect.equal
                            (Err "I ran into a `fail` decoder: Unsupported version: 3")
        ]


main : Runner.TestProgram
main =
    Runner.run tests
