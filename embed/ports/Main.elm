module Main exposing (..)

import Html exposing (Html, div, p, em, strong, text)


type alias Flags =
    { speechSynthesisSupported : Bool }


main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { speechSynthesisSupported : Bool }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { speechSynthesisSupported = flags.speechSynthesisSupported }, Cmd.none )


type Msg
    = None


update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ supportView model ]


supportView : Model -> Html Msg
supportView model =
    let
        ( tag, msg ) =
            if model.speechSynthesisSupported then
                ( em, "Speech synthesis is supported." )
            else
                ( strong, "Warning: speech synthesis is not supported!" )
    in
        p []
            [ tag [] [ text msg ] ]
