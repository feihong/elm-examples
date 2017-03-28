module Main exposing (..)

import Html exposing (Html, div, p, span, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Random
import Char
import String


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


generate : Cmd Msg
generate =
    Random.generate NewNumber (Random.int 0x4E00 0x9FFF)



-- MODEL


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0, generate )



-- UPDATE


type Msg
    = Generate
    | NewNumber Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Generate ->
            ( model, generate )

        NewNumber num ->
            ( num, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        hanzi =
            model |> Char.fromCode |> String.fromChar
    in
        div []
            [ p []
                [ text "Ordinal: "
                , text (toString model)
                ]
            , div []
                [ text "Character: "
                , span [ style [ ( "font-size", "5rem" ) ] ]
                    [ text hanzi ]
                ]
            , button [ onClick Generate ] [ text "Generate" ]
            ]
