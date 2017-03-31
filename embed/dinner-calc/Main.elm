module Main exposing (..)

import Dict exposing (Dict)
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


hasIndividualItem : List Item -> Bool
hasIndividualItem items =
    items
        |> List.any
            (\item ->
                case item.payer of
                    Attendee _ ->
                        True

                    Group ->
                        False
            )


individualAmounts items =
    let
        -- Incrementally add up amounts for each individual payer
        updateDict item dict =
            case item.payer of
                Attendee name ->
                    updateAdd name item.amount dict

                Group ->
                    dict
    in
        items
            |> List.foldl updateDict Dict.empty
            |> Dict.toList



{- Update the value at the given key. If there is already a value there, add the
   new value to the old value.
-}


updateAdd : String -> number -> Dict String number -> Dict String number
updateAdd key newValue dict =
    let
        justAdd a b =
            Just <| (Maybe.withDefault 0 a) + b
    in
        Dict.update key (\oldValue -> justAdd oldValue newValue) dict



-- UPDATE


update msg model =
    ( model, Cmd.none )



-- VIEW


view model =
    div []
        [ pairDiv "Subtotal amount" <| subtotal model
        , pairDiv "Tax" <| tax model
        , pairDiv "Tip" <| tip model
        , pairDiv "Total amount" <| total model
        , breakdownView model
        ]


pairDiv label amount =
    div []
        [ text <| label ++ ": "
        , text <| toString amount
        ]


breakdownView model =
    if hasIndividualItem model.items then
        -- div [] (individualPairDivs model)
        div [] [ text "todo" ]
    else
        pairDiv "Everyone pays" <| sharedAmount model


individualPairDivs model =
    let
        pdiv ( k, v ) =
            pairDiv (k ++ " also pays") v
    in
        individualAmounts model.items
            |> List.map pdiv
