{- todo:
   - dismiss dialog with esc key
   - set focus to new payer input
   - add on key enter
   - items view
   - item form
-}


module Main exposing (..)

import Html exposing (..)
import Dom
import Task
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


samplePayers =
    [ "Bob", "Hobo" ]


init : ( Model, Cmd Msg )
init =
    { taxPercent = 9.75
    , tipPercent = 20.0
    , groupSize = 6
    , taxPercentErr = ""
    , tipPercentErr = ""
    , groupSizeErr = ""
    , individualPayers = samplePayers
    , newPayer = ""
    , newPayerErr = ""
    , showDialog = False
    , items = sampleItems
    , newItemForm = ItemForm "" "" ""
    }
        ! []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTaxPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | taxPercent = value, taxPercentErr = "" } |> noCmd

                Err err ->
                    { model | taxPercentErr = err } |> noCmd

        ChangeTipPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | tipPercent = value, tipPercentErr = "" } |> noCmd

                Err err ->
                    { model | tipPercentErr = err } |> noCmd

        ChangeGroupSize str ->
            case stringToInt str of
                Ok value ->
                    { model | groupSize = value, groupSizeErr = "" } |> noCmd

                Err err ->
                    { model | groupSizeErr = err } |> noCmd

        RemovePayer name ->
            let
                newPayers =
                    model.individualPayers
                        |> List.filter (\payer -> payer /= name)
            in
                { model | individualPayers = newPayers } |> noCmd

        AddPayer ->
            let
                newPayers () =
                    model.individualPayers ++ [ model.newPayer ]
            in
                if String.isEmpty model.newPayerErr then
                    { model
                        | individualPayers = newPayers ()
                        , showDialog = False
                    }
                        |> noCmd
                else
                    model ! []

        UpdateNewPayer name ->
            let
                err =
                    if List.member name model.individualPayers then
                        "That payer already exists"
                    else
                        ""
            in
                { model | newPayer = name, newPayerErr = err } |> noCmd

        ToggleDialog ->
            if model.showDialog == False then
                { model
                    | showDialog = not model.showDialog
                    , newPayer = ""
                    , newPayerErr = ""
                }
                    ! [ Dom.focus "new-payer-input" |> Task.attempt FocusResult ]
            else
                { model | showDialog = not model.showDialog } ! []

        FocusResult result ->
            let
                _ =
                    Debug.log "focus result" result
            in
                model ! []

        _ ->
            model ! []


noCmd model =
    model ! []
