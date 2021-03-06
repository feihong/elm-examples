module Main exposing (..)

import Html exposing (Html, div, button, text)
import Random
import HanziGenerator
import HanziView


main : Program Never Model Msg
main =
    Html.program
        { init = ( "", generateHanzi )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    String


type Msg
    = Generate
    | NewHanzi String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Generate ->
            ( model, generateHanzi )

        NewHanzi value ->
            ( value, Cmd.none )


generateHanzi : Cmd Msg
generateHanzi =
    Random.generate NewHanzi HanziGenerator.hanziGenerator



-- VIEW


view : Model -> Html Msg
view model =
    HanziView.hanziView model Generate
