module Main exposing (..)

import Html exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type Payer
    = Group
    | Attendee String


type alias Item =
    { payer : Payer
    , name : String
    , amount : Float
    }


type alias Model =
    { taxPercent : Float
    , tipPercent : Float
    , items : List Item
    }


sampleItems =
    [ { payer = Group, name = "Chef Ping Platter", amount = 12.35 }
    , { payer = Group, name = "Green Bean Casserole", amount = 5.5 }
    , { payer = Attendee "Norman", name = "Maotai", amount = 15.0 }
    , { payer = Attendee "Cameron", name = "Mojito", amount = 9.15 }
    ]


init =
    ( { taxPercent = 9.75, tipPercent = 20, items = sampleItems }
    , Cmd.none
    )



-- UPDATE


update msg model =
    ( model, Cmd.none )



-- VIEW


view model =
    text ""
