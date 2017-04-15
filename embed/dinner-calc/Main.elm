{- todo:
   - horizontal number fields
   - input group addon %
   - individual payers view
   - items view
   - item form
-}


module Main exposing (..)

import Html exposing (..)
import Models exposing (..)
import Views
import Helpers exposing (..)


main =
    Html.program
        { init = init
        , view = Views.view
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


samplePayers =
    [ "Bob", "Hobo" ]


init =
    { taxPercent = 9.75
    , tipPercent = 20.0
    , groupSize = 6
    , taxPercentErr = ""
    , tipPercentErr = ""
    , groupSizeErr = ""
    , individualPayers = samplePayers
    , items = sampleItems
    , newItemForm = ItemForm "" "" ""
    }
        ! []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTaxPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | taxPercent = value, taxPercentErr = "" } |> noCmd

                Err err ->
                    { model | taxPercentErr = err } |> noCmd

        ChangeTipPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | tipPercent = value, tipPercentErr = "" } |> noCmd

                Err err ->
                    { model | tipPercentErr = err } |> noCmd

        ChangeGroupSize str ->
            case stringToInt str of
                Ok value ->
                    { model | groupSize = value, groupSizeErr = "" } |> noCmd

                Err err ->
                    { model | groupSizeErr = err } |> noCmd

        ChangeNewItemName str ->
            let
                itemForm =
                    model.newItemForm

                newItemForm =
                    { itemForm | name = str }
            in
                { model | newItemForm = newItemForm } ! []

        _ ->
            model ! []


noCmd model =
    model ! []
