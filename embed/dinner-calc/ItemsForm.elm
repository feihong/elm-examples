module ItemsForm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, on)
import Models exposing (..)


view state =
    div []
        []


itemForm values =
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
