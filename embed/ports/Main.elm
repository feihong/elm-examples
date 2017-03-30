port module Main exposing (..)

import Html exposing (Html, div, p, em, strong, text, button, input)
import Html.Attributes exposing (value, size, autofocus)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Json


port speak : String -> Cmd msg


type alias Flags =
    { speechSynthesisSupported : Bool }


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { speechSynthesisSupported : Bool
    , text : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { speechSynthesisSupported = flags.speechSynthesisSupported
      , text = "Hey hey we're the Monkees"
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Speak
    | ChangeText String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Speak ->
            ( model, speak model.text )

        ChangeText text ->
            ( { model | text = text }, Cmd.none )


onKeyEnter msg =
    let
        checkEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not enter key"
    in
        on "keypress" (Json.andThen checkEnter keyCode)



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ supportView model
        , div []
            [ input
                [ value model.text
                , onInput ChangeText
                , onKeyEnter Speak
                , size 40
                , autofocus True
                ]
                []
            , button [ onClick Speak ] [ text "Speak" ]
            ]
        ]


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
