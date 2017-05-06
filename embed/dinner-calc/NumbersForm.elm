module NumbersForm exposing (view, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Models exposing (..)
import Util exposing (..)
import Helpers exposing (..)


update : NumbersFormMsg -> Model -> Model
update msg ({ numbersForm } as model) =
    case msg of
        ChangeTaxPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | taxPercent = value }
                        |> updateForm { numbersForm | taxPercentErr = "" }

                Err err ->
                    model |> updateForm { numbersForm | taxPercentErr = err }

        ChangeTipPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | tipPercent = value }
                        |> updateForm { numbersForm | tipPercentErr = "" }

                Err err ->
                    model |> updateForm { numbersForm | tipPercentErr = err }

        ChangeSubtotal str ->
            case stringToCents str of
                Ok value ->
                    { model | subtotal = value }
                        |> updateForm { numbersForm | subtotalErr = "" }

                Err err ->
                    model |> updateForm { numbersForm | subtotalErr = err }


updateForm form model =
    { model | numbersForm = form }


view : Model -> Html Msg
view { taxPercent, tipPercent, subtotal, numbersForm } =
    div []
        [ div
            [ class "form-group"
            , classList
                [ ( "has-error", stringIsNotEmpty numbersForm.taxPercentErr ) ]
            ]
            [ label [] [ text "Tax" ]
            , div
                [ class "input-group" ]
                [ input
                    [ type_ "number"
                    , class "form-control"
                    , defaultValue <| toString taxPercent
                    , size 5
                    , onInput (NumbersFormMsg << ChangeTaxPercent)
                    ]
                    []
                , span [ class "input-group-addon" ] [ text "%" ]
                ]
            , div [ class "help-block" ] [ text numbersForm.taxPercentErr ]
            ]
        , div
            [ class "form-group"
            , classList
                [ ( "has-error", stringIsNotEmpty numbersForm.tipPercentErr ) ]
            ]
            [ label [] [ text "Tip" ]
            , div
                [ class "input-group" ]
                [ input
                    [ type_ "number"
                    , class "form-control"
                    , defaultValue <| toString tipPercent
                    , size 5
                    , onInput (NumbersFormMsg << ChangeTipPercent)
                    ]
                    []
                , span [ class "input-group-addon" ] [ text "%" ]
                ]
            , div [ class "help-block" ] [ text numbersForm.tipPercentErr ]
            ]
        , div
            [ class "form-group"
            , classList
                [ ( "has-error", stringIsNotEmpty numbersForm.subtotalErr ) ]
            ]
            [ label [] [ text "Subtotal" ]
            , div
                [ class "input-group" ]
                [ span [ class "input-group-addon" ] [ text "$" ]
                , input
                    [ type_ "number"
                    , class "form-control"
                    , defaultValue <| centsToString subtotal
                    , size 5
                    , onInput (NumbersFormMsg << ChangeSubtotal)
                    ]
                    []
                ]
            , div [ class "help-block" ] [ text numbersForm.subtotalErr ]
            ]
        ]
