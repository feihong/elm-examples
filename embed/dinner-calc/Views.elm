module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Decode
import Models exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ topForm model
        , h2 [] [ text "Individual Payers" ]
        , individualPayersView model
        , h2 [] [ text "Items" ]
        , itemsView model
        ]


topForm : Model -> Html Msg
topForm model =
    div []
        [ numInput "tax" "Tax" "%" model.taxPercent model.taxPercentErr ChangeTaxPercent
        , numInput "tip" "Tip" "%" model.tipPercent model.tipPercentErr ChangeTipPercent
        , numInput "groupSize" "Group size" "people" model.groupSize model.groupSizeErr ChangeGroupSize
        ]


individualPayersView model =
    let
        view payer =
            div [ class "payer", onClick <| RemovePayer payer ]
                [ icon "remove", text payer ]
    in
        div [ class "payers" ]
            (button [ class "btn btn-default" ] [ icon "plus", text "Add" ]
                :: (model.individualPayers |> List.map view)
            )


icon name =
    span [ class <| "glyphicon glyphicon-" ++ name ] []


numInput id_ label_ addon defaultValue_ errMsg msg =
    div
        [ classList
            [ ( "form-group", True )
            , ( "has-error", not <| String.isEmpty errMsg )
            ]
        ]
        [ label [ for id_, class "control-label" ]
            [ text label_ ]
        , div
            [ class "input-group" ]
            [ input
                [ id id_
                , type_ "number"
                , class "form-control"
                , defaultValue <| toString defaultValue_
                , size 5
                , onInput msg
                ]
                []
            , span [ class "input-group-addon" ] [ text addon ]
            ]
        , div [ class "help-block" ] [ text errMsg ]
        ]


itemsView model =
    div [ class "items" ]
        [ addItemForm model
        ]


addItemForm model =
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
                    , onInput ChangeNewItemName
                    ]
                    []
                ]
            , div [ class "col-xs-12 col-sm-3" ]
                [ input
                    [ class "form-control"
                    , type_ "number"
                    , placeholder "Amount"
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
