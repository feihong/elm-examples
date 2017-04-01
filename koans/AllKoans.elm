port module AllKoans exposing (..)

import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)
import Test exposing (describe)
import MaybeKoans
import JsonKoans
import ListKoans


main : TestProgram
main =
    run emit <|
        describe "All koans"
            [ MaybeKoans.tests
            , JsonKoans.tests
            , ListKoans.tests
            ]


port emit : ( String, Value ) -> Cmd msg
