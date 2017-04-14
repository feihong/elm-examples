module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, on, keyCode)
import Json.Decode as Decode
import Models exposing (..)


view model =
    div []
        [ numInput "tax" "Tax %" model.taxPercent model.taxPercentErr ChangeTaxPercent
        , numInput "tip" "Tip %" model.tipPercent model.tipPercentErr ChangeTipPercent
        , numInput "groupSize" "Group size" model.groupSize model.groupSizeErr ChangeGroupSize
        , h2 [] [ text "Items" ]
        , itemsView model
        ]


numInput id_ label_ defaultValue_ errMsg msg =
    div
        [ classList
            [ ( "form-group", True )
            , ( "has-error", not <| String.isEmpty errMsg )
            ]
        ]
        [ label [ for id_, class "control-label" ] [ text label_ ]
        , input
            [ id id_
            , type_ "number"
            , class "form-control"
            , defaultValue <| toString defaultValue_
            , onInput msg
            ]
            []
        , div [ class "help-block" ] [ text errMsg ]
        ]


itemsView model =
    div [ class "items" ]
        [ emptyItemView model.newItemForm
        ]


emptyItemView { payer, name, amount } =
    div [ class "item" ]
        [ select []
            [ option [ value payer ] [ text "Group" ]
            , option [] [ text "Add attendee" ]
            ]
        , input
            [ class "name"
            , placeholder "Name"
            , value name
            , onInput ChangeNewItemName
            ]
            []
        , input
            [ type_ "number"
            , placeholder "Amount"
            , value amount
            ]
            []
        ]


pairDiv label amount =
    div []
        [ text <| label ++ ": "
        , text <| toString amount
        ]


onKeyEnter : msg -> Html.Attribute msg
onKeyEnter msg =
    let
        decoder =
            keyCode
                |> Decode.andThen
                    (\code ->
                        if code == 13 then
                            Decode.succeed msg
                        else
                            Decode.fail "not enter key"
                    )
    in
        on "keypress" decoder
