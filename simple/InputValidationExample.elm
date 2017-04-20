module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Decode


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
    { taxPercent : Float
    , taxPercentStr : String
    , taxPercentErr : String
    }


initModel =
    { taxPercent = 9.75
    , taxPercentStr = "9.75"
    , taxPercentErr = ""
    }



-- UPDATE


type Msg
    = NoOp
    | ChangeTaxPercent String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTaxPercent str ->
            let
                newModel =
                    case Decode.decodeString Decode.float str of
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



-- VIEW


view : Model -> Html Msg
view model =
    div [ style [ ( "padding", "1rem" ) ] ]
        [ input
            [ type_ "text"
            , value model.taxPercentStr
            , onInput ChangeTaxPercent
            , autofocus True
            ]
            []
        , div [ class "help-block", style [ ( "color", "firebrick" ) ] ]
            [ text model.taxPercentErr ]
        ]
