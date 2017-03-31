module Main exposing (..)

import Dict
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
    , { payer = Group, name = "Deep Dish Pizza", amount = 16.0 }
    , { payer = Attendee "Norman", name = "Maotai", amount = 15.0 }
    , { payer = Attendee "Cameron", name = "Mojito", amount = 5 }
    , { payer = Attendee "Cameron", name = "Margarita", amount = 4.5 }
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
    (subtotal model) + (tip model) + (tax model)


tip model =
    (subtotal model) * (model.tipPercent / 100)


tax model =
    (subtotal model) * (model.taxPercent / 100)


sharedAmount model =
    model.items
        |> List.filter (\item -> item.payer == Group)
        |> List.map (\item -> item.amount)
        |> List.sum
        |> flip (/) model.groupSize


otherAmounts model =
    let
        -- Add a and b together, but have a default to 0
        add a b =
            Just <| (Maybe.withDefault 0 a) + b

        -- Incrementally add up amounts for each individual payer
        updateDict item dict =
            case item.payer of
                Group ->
                    dict

                Attendee name ->
                    Dict.update name (\v -> add v item.amount) dict
    in
        model.items
            |> List.foldl updateDict Dict.empty
            |> Dict.toList



-- UPDATE


update msg model =
    ( model, Cmd.none )



-- VIEW


view model =
    div []
        [ pairDiv "Subtotal amount" <| subtotal model
        , pairDiv "Tax" <| tax model
        , pairDiv "Tip" <| tip model
        , pairDiv "Total amount (after tip and tax)" <| total model
        , pairDiv "Everyone pays" <| sharedAmount model
        , div [] (otherPairDivs model)
        ]


pairDiv label amount =
    div []
        [ text <| label ++ ": "
        , text <| toString amount
        ]


otherPairDivs model =
    let
        pdiv ( k, v ) =
            pairDiv (k ++ " also pays") v
    in
        otherAmounts model
            |> List.map pdiv
