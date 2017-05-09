{- todo:
   - dismiss dialog with esc key
   - don't allow duplicates inside attendees textarea
   - items form
-}


module Main exposing (..)

import Html exposing (..)
import Dom
import Task
import Models exposing (..)
import Init exposing (init)
import Views
import NumbersForm exposing (..)
import Attendees exposing (..)
import Helpers exposing (..)
import Util exposing (..)


-- import ItemsForm


main =
    Html.program
        { init = init
        , view = Views.view
        , update = update
        , subscriptions = always Sub.none
        }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        NumbersFormMsg formMsg ->
            NumbersForm.update formMsg model |> noCmd

        AttendeesMsg attMsg ->
            let
                ( newModel, cmd ) =
                    Attendees.update attMsg model
            in
                ( newModel, cmd )



-- UPDATE
-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
--     case msg of
--         ChangeTaxPercent str ->
--             case stringToPercent str of
--                 Ok value ->
--                     { model | taxPercent = value, taxPercentErr = "" } |> noCmd
--                 Err err ->
--                     { model | taxPercentErr = err } |> noCmd
--         ChangeTipPercent str ->
--             case stringToPercent str of
--                 Ok value ->
--                     { model | tipPercent = value, tipPercentErr = "" } |> noCmd
--                 Err err ->
--                     { model | tipPercentErr = err } |> noCmd
--         ChangeGroupSize str ->
--             case stringToInt str of
--                 Ok value ->
--                     { model | groupSize = value, groupSizeErr = "" } |> noCmd
--                 Err err ->
--                     { model | groupSizeErr = err } |> noCmd
--         RemovePayer name ->
--             let
--                 newPayers =
--                     model.individualPayers
--                         |> List.filter (\payer -> payer /= name)
--             in
--                 { model | individualPayers = newPayers } |> noCmd
--         UpdateNewPayer name ->
--             let
--                 trimmedName =
--                     String.trim name
--                 alreadyExists =
--                     ifInvalid <| flip List.member model.individualPayers
--                 error =
--                     trimmedName
--                         |> Validate.eager
--                             [ ifBlank "Please enter a name"
--                             , ifIsGroup "Name cannot be \"Group\""
--                             , alreadyExists "That payer already exists"
--                             ]
--             in
--                 { model
--                     | newPayer = name
--                     , newPayerErr = Maybe.withDefault "" error
--                 }
--                     |> noCmd
--         AddPayer ->
--             let
--                 trimmedName =
--                     String.trim model.newPayer
--                 addPayer name =
--                     model.individualPayers ++ [ name ]
--             in
--                 if String.isEmpty model.newPayerErr then
--                     { model
--                         | individualPayers = addPayer trimmedName
--                         , showDialog = False
--                     }
--                         |> noCmd
--                 else
--                     model |> noCmd
--         ToggleDialog ->
--             if model.showDialog == False then
--                 { model
--                     | showDialog = not model.showDialog
--                     , newPayer = ""
--                     , newPayerErr = ""
--                 }
--                     ! [ Dom.focus "new-payer-input" |> Task.attempt FocusResult ]
--             else
--                 { model | showDialog = not model.showDialog } ! []
--         FocusResult result ->
--             model ! []
--         SetFormState formMsg ->
--             let
--                 ( newState, maybeMsg ) =
--                     ItemsForm.update formConfig formMsg model.formState
--                 newModel =
--                     { model | formState = newState }
--             in
--                 case maybeMsg of
--                     Nothing ->
--                         newModel ! []
--                     Just updateMsg ->
--                         update updateMsg newModel
--         AddItem payer name amount ->
--             let
--                 payer_ =
--                     if payer == "Group" then
--                         Group
--                     else
--                         Attendee payer
--                 newItems =
--                     model.items ++ [ Item payer_ name amount ]
--             in
--                 { model | items = newItems } |> noCmd
--         _ ->
--             model ! []
