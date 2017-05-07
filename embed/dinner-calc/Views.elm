module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Dialog
import Models exposing (..)
import ViewUtil
import NumbersForm exposing (..)
import Attendees exposing (..)


-- import ItemsForm


view : Model -> Html Msg
view model =
    div []
        [ NumbersForm.view model
        , Attendees.view model
        ]



-- div []
--     [ topForm model
--     , h2 [] [ text "Individual Payers" ]
--     , individualPayersView model
--     , h2 [] [ text "Items" ]
--     , Html.map SetFormState <| ItemsForm.view model.formState model.individualPayers
--     , Dialog.view
--         (if model.showDialog then
--             Just <| dialogConfig model
--          else
--             Nothing
--         )
--     ]
-- topForm : Model -> Html Msg
-- topForm model =
--     div []
--         [ numInput "tax" "Tax" "%" model.taxPercent model.taxPercentErr ChangeTaxPercent
--         , numInput "tip" "Tip" "%" model.tipPercent model.tipPercentErr ChangeTipPercent
--         , numInput "groupSize" "Group size" "people" model.groupSize model.groupSizeErr ChangeGroupSize
--         ]
-- pairDiv label amount =
--     div []
--         [ text <| label ++ ": "
--         , text <| toString amount
--         ]
-- dialogConfig : Model -> Dialog.Config Msg
-- dialogConfig model =
--     { closeMessage = Just ToggleDialog
--     , containerClass = Nothing
--     , header = Just (h4 [ class "modal-title" ] [ text "Add individual payer" ])
--     , body =
--         Just <|
--             div
--                 [ classList
--                     [ ( "form-group", True )
--                     , ( "has-error", not <| String.isEmpty model.newPayerErr )
--                     ]
--                 ]
--                 [ input
--                     [ id "new-payer-input"
--                     , class "form-control"
--                     , placeholder "Name"
--                     , value model.newPayer
--                     , onInput UpdateNewPayer
--                     , ViewUtil.onKeyEnter AddPayer
--                     ]
--                     []
--                 , div [ class "help-block" ] [ text model.newPayerErr ]
--                 ]
--     , footer =
--         Just
--             (div []
--                 [ button [ class "btn btn-default", onClick ToggleDialog ]
--                     [ text "Cancel" ]
--                 , button [ class "btn btn-primary", onClick AddPayer ]
--                     [ text "Add" ]
--                 ]
--             )
--     }
