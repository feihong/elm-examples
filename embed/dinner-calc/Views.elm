module Views exposing (..)

import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Models exposing (..)


view ({ errors } as model) =
    div []
        [ numInput "tax" "Tax %" model.taxPercent ChangeTaxPercent errors
        , numInput "tip" "Tip %" model.tipPercent ChangeTipPercent errors
        , numInput "groupSize" "Group size" model.groupSize ChangeGroupSize errors
        , h2 [] [ text "Items" ]
        , itemsView model.items
        ]


numInput id_ label_ defaultValue_ msg errors =
    let
        errMsg =
            Dict.get id_ errors
    in
        div
            [ classList
                [ ( "form-group", True )
                , ( "has-error", errMsg /= Nothing )
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
            , div [ class "help-block" ] [ text <| Maybe.withDefault "" errMsg ]
            ]


itemsView items =
    div [ class "items" ]
        [ emptyItemView
        ]


emptyItemView =
    div [ class "item" ]
        [ select []
            [ option [ defaultValue "Group" ] [ text "Group" ]
            , option [] [ text "Add attendee" ]
            ]
        , input [ class "name", placeholder "Name" ] []
        , input [ type_ "number", placeholder "Amount" ] []
        ]


pairDiv label amount =
    div []
        [ text <| label ++ ": "
        , text <| toString amount
        ]
