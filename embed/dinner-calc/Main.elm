{- todo:
   - dismiss dialog with esc key
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


init : ( Model, Cmd Msg )
init =
    initialModel ! []



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
                if String.isEmpty model.newPayer then
                    { model | newPayerErr = "Name must not be blank" } |> noCmd
                else if String.isEmpty model.newPayerErr then
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
