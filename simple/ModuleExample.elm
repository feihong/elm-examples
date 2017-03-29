module Main exposing (..)

import Html exposing (Html, div, button, text)
import Html.Attributes
import Html.Events exposing (onClick)
import Random
import Hanzi
import Css exposing (px, color, fontSize, margin, textShadow3)
import Css.Colors exposing (..)


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
    Random.generate NewHanzi Hanzi.hanziGenerator



-- VIEW


rem_ : Float -> Css.Rem
rem_ =
    Css.rem


styles : List Css.Mixin -> Html.Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style


view : Model -> Html Msg
view model =
    let
        hanziStyles =
            styles
                [ color purple
                , fontSize (rem_ 8)
                , textShadow3 (px 3) (px 5) silver
                ]
    in
        div [ styles [ margin (rem_ 1) ] ]
            [ div [ hanziStyles ] [ text model ]
            , button [ onClick Generate ] [ text "Generate" ]
            ]
