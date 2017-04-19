{- todo:
   - dismiss dialog with esc key
   - items view
   - item form
-}


module Main exposing (..)

import Html exposing (..)
import Dom
import Task
import Validate exposing (Validator, ifBlank, ifInvalid)
import Models exposing (..)
import Views
import Helpers exposing (..)
import ItemsForm


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


formConfig : ItemsForm.Config Msg
formConfig =
    { addMsg = AddItem
    , updateMsg = UpdateItem
    , removeMsg = RemoveItem
    }


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

        UpdateNewPayer name ->
            let
                trimmedName =
                    String.trim name

                alreadyExists =
                    ifInvalid <| flip List.member model.individualPayers

                error =
                    trimmedName
                        |> Validate.eager
                            [ ifBlank "Please enter a name"
                            , ifIsGroup "Name cannot be \"Group\""
                            , alreadyExists "That payer already exists"
                            ]
            in
                { model
                    | newPayer = name
                    , newPayerErr = Maybe.withDefault "" error
                }
                    |> noCmd

        AddPayer ->
            let
                trimmedName =
                    String.trim model.newPayer

                addPayer name =
                    model.individualPayers ++ [ name ]
            in
                if String.isEmpty model.newPayerErr then
                    { model
                        | individualPayers = addPayer trimmedName
                        , showDialog = False
                    }
                        |> noCmd
                else
                    model |> noCmd

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
            model ! []

        SetFormState formMsg ->
            let
                ( newState, maybeMsg ) =
                    ItemsForm.update formConfig formMsg model.formState

                newModel =
                    { model | formState = newState }
            in
                case maybeMsg of
                    Nothing ->
                        newModel ! []

                    Just updateMsg ->
                        update updateMsg newModel

        AddItem payer name amount ->
            let
                _ =
                    Debug.log "add item" ( payer, name, amount )
            in
                model ! []

        _ ->
            model ! []


noCmd model =
    model ! []


ifIsGroup : error -> Validator error String
ifIsGroup =
    ifInvalid <| (==) "Group"
