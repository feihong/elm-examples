module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode exposing (decodeString, float, andThen, fail, succeed)


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Model =
    { subtotal : Float
    , taxPercent : Float
    , taxPercentStr : String
    , taxPercentErr : String
    }


initModel =
    { subtotal = 25
    , taxPercent = 9.75
    , taxPercentStr = "9.75"
    , taxPercentErr = ""
    }



-- UPDATE


type Msg
    = NoOp
    | ChangeSubtotal String
    | ChangeTaxPercent String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSubtotal str ->
            let
                newSubtotal =
                    case decodeString float str of
                        Ok value ->
                            value

                        Err _ ->
                            model.subtotal
            in
                { model | subtotal = newSubtotal } ! []

        ChangeTaxPercent str ->
            let
                newModel =
                    case decodePercent str of
                        Ok value ->
                            { model
                                | taxPercent = value
                                , taxPercentStr = str
                                , taxPercentErr = ""
                            }

                        Err err ->
                            { model
                                | taxPercentErr = err
                                , taxPercentStr = str
                            }
            in
                newModel ! []

        NoOp ->
            model ! []


isBlank =
    String.trim >> String.isEmpty


decodePercent str =
    if isBlank str then
        Err "Please enter a value"
    else
        case decodeString float str of
            Ok num ->
                if num >= 100 then
                    Err "Must be less then 100"
                else if num <= 0 then
                    Err "Must be greater than 0"
                else
                    Ok num

            Err err ->
                Err "Not a valid percent value"



-- VIEW


view : Model -> Html Msg
view model =
    let
        total =
            model.subtotal * (1 + model.taxPercent / 100)
    in
        div [ style [ ( "padding", "1rem" ) ] ]
            [ div []
                [ input
                    [ value <| toString model.subtotal
                    , onInput ChangeSubtotal
                    ]
                    []
                ]
            , div []
                [ input
                    [ type_ "text"
                    , value model.taxPercentStr
                    , onInput ChangeTaxPercent
                    , autofocus True
                    ]
                    []
                , span [] [ text "%" ]
                ]
            , div [ class "help-block", style [ ( "color", "firebrick" ) ] ]
                [ text model.taxPercentErr ]
            , div []
                [ text <| "Total: " ++ toString total
                ]
            ]
