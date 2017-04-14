module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
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
    , errors = Dict.empty
    }
        ! []



-- UPDATE


type Msg
    = Temp String
    | ChangeTaxPercent String
    | ChangeTipPercent String
    | ChangeGroupSize String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTaxPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | taxPercent = value } |> removeError "tax" |> noCmd

                Err err ->
                    model |> addError "tax" err |> noCmd

        ChangeTipPercent str ->
            case stringToPercent str of
                Ok value ->
                    { model | tipPercent = value } |> removeError "tip" |> noCmd

                Err err ->
                    model |> addError "tip" err |> noCmd

        ChangeGroupSize str ->
            case stringToInt str of
                Ok value ->
                    { model | groupSize = value } |> removeError "groupSize" |> noCmd

                Err err ->
                    model |> addError "groupSize" err |> noCmd

        _ ->
            model ! []


addError key value model =
    { model | errors = Dict.insert key value model.errors }


removeError key model =
    { model | errors = Dict.remove key model.errors }


noCmd model =
    model ! []



-- removeError key model =
-- VIEW


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
        , input [ placeholder "Name" ] []
        , input [ type_ "number", placeholder "Amount" ] []
        ]


pairDiv label amount =
    div []
        [ text <| label ++ ": "
        , text <| toString amount
        ]
