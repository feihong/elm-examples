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
        , individualPayersView model
        , h2 [] [ text "Items" ]
        , itemsView model
        ]


individualPayersView model =
    text ""


icon name =
    span [ class <| "glyphicon glyphicon-" ++ name ] []


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
    div [ class "form-horizontal" ]
        [ div [ class "form-group" ]
            [ div [ class "col-xs-12 col-sm-3" ]
                [ select [ class "form-control" ]
                    [ option [ value "" ] [ text "Group" ]
                    , option [ disabled True ] [ text "-----" ]
                    , option [] [ text "New individual payer..." ]
                    ]
                ]
            , div [ class "col-xs-12 col-sm-6" ]
                [ input
                    [ class "form-control"
                    , placeholder "Name"
                    , value name
                    , onInput ChangeNewItemName
                    ]
                    []
                ]
            , div [ class "col-xs-12 col-sm-3" ]
                [ input
                    [ class "form-control"
                    , type_ "number"
                    , placeholder "Amount"
                    , value amount
                    ]
                    []
                ]
            ]
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
