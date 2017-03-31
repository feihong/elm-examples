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
    , groupSize : Int
    , items : List Item
    }


sampleItems =
    [ { payer = Group, name = "Chef Ping Platter", amount = 12.35 }
    , { payer = Group, name = "Green Bean Casserole", amount = 5.5 }
    , { payer = Attendee "Norman", name = "Maotai", amount = 15.0 }
    , { payer = Attendee "Cameron", name = "Mojito", amount = 9.15 }
    ]


init =
    ( { taxPercent = 9.75
      , tipPercent = 20
      , groupSize = 6
      , items = sampleItems
      }
    , Cmd.none
    )


subtotal model =
    model.items
        |> List.map (\item -> item.amount)
        |> List.sum


total model =
    let
        x =
            subtotal model

        tip =
            x * (model.tipPercent / 100)

        tax =
            x * (model.taxPercent / 100)
    in
        x + tip + tax


individualAmount model =
    model.items
        |> List.filter (\item -> item.payer == Group)
        |> List.map (\item -> item.amount)
        |> List.sum
        |> flip (/) model.groupSize



-- UPDATE


update msg model =
    ( model, Cmd.none )



-- VIEW


view model =
    div []
        [ pairDiv "Subtotal amount" <| subtotal model
        , pairDiv "Total amount" <| total model
        , pairDiv "Everyone pays" <| individualAmount model
        ]


pairDiv label amount =
    div []
        [ text <| label ++ ": "
        , text <| toString amount
        ]
