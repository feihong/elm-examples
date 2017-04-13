module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Helpers exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


sampleItems =
    [ { payer = Group, name = "Chef Ping Platter", amount = 1235 }
    , { payer = Group, name = "Green Bean Casserole", amount = 550 }
    , { payer = Group, name = "Deep Dish Pizza", amount = 1600 }
    , { payer = Attendee "Norman", name = "Maotai", amount = 1500 }
    , { payer = Attendee "Cameron", name = "Mojito", amount = 500 }
    , { payer = Attendee "Cameron", name = "Margarita", amount = 450 }
    ]


init =
    { taxPercent = 9.75
    , tipPercent = 20.0
    , groupSize = 6
    , items = sampleItems
    }
        ! []



-- UPDATE


update msg model =
    model ! []



-- VIEW


view model =
    div []
        [ numInput "Tax %" model.taxPercent
        , numInput "Tip %" model.tipPercent
        , numInput "Group size" model.groupSize
        , h2 [] [ text "Items" ]
        , itemsView model.items
        ]


numInput label_ value_ =
    div [ class "form-group" ]
        [ label [] [ text label_ ]
        , input [ type_ "number", class "form-control", value <| toString value_ ] []
        ]


itemsView items =
    text ""


pairDiv label amount =
    div []
        [ text <| label ++ ": "
        , text <| toString amount
        ]
