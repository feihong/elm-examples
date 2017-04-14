module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Models exposing (..)
import Views
import Helpers exposing (..)


main =
    Html.program
        { init = init
        , view = Views.view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


sampleItems =
    [ { payer = Group, name = "Chef Ping Platter", amount = 1235 }
    , { payer = Group, name = "Green Bean Casserole", amount = 550 }
    , { payer = Group, name = "Deep Dish Pizza", amount = 1600 }
    , { payer = Attendee "Norman", name = "Maotai", amount = 1500 }
    , { payer = Attendee "Cameron", name = "Mojito", amount = 500 }
    , { payer = Attendee "Cameron", name = "Margarita", amount = 450 }
    ]


init =
    { taxPercent = 9.75
    , tipPercent = 20.0
    , groupSize = 6
    , items = sampleItems
    , errors = Dict.empty
    }
        ! []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTaxPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | taxPercent = value } |> removeError "tax" |> noCmd

                Err err ->
                    model |> addError "tax" err |> noCmd

        ChangeTipPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | tipPercent = value } |> removeError "tip" |> noCmd

                Err err ->
                    model |> addError "tip" err |> noCmd

        ChangeGroupSize str ->
            case stringToInt str of
                Ok value ->
                    { model | groupSize = value } |> removeError "groupSize" |> noCmd

                Err err ->
                    model |> addError "groupSize" err |> noCmd

        _ ->
            model ! []


addError key value model =
    { model | errors = Dict.insert key value model.errors }


removeError key model =
    { model | errors = Dict.remove key model.errors }


noCmd model =
    model ! []
