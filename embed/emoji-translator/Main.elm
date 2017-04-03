module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Emojifier exposing (emojify, textify)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type TranslationMode
    = TextToEmoji
    | EmojiToText


type alias Model =
    { message : String
    , key : Char
    , mode : TranslationMode
    }


init =
    ( -- { message = "ABCD, WXYZ; abcd, wxyz!"
      { message = "😀😁😂😃"
      , key = '😀'
      , mode = TextToEmoji
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeMessage String
    | SwitchMode TranslationMode


update msg model =
    case msg of
        ChangeMessage str ->
            { model | message = str } ! []

        SwitchMode mode ->
            { model | mode = mode } ! []



-- SUBSCRIPTIONS


subscriptions model =
    Sub.none



-- VIEW


view model =
    div []
        [ input
            [ class "message"
            , placeholder "Let's translate!"
            , value model.message
            , onInput ChangeMessage
            ]
            []
        , choiceView model
        , outputView model
        ]


choiceView model =
    div []
        [ radio "Text to emoji" (SwitchMode TextToEmoji)
        , radio "Emoji to text" (SwitchMode EmojiToText)
        ]


radio title msg =
    label
        []
        [ input [ type_ "radio", name "translation-mode", onClick msg ] []
        , text title
        ]


outputView model =
    let
        output =
            case model.mode of
                TextToEmoji ->
                    emojify model.key model.message

                EmojiToText ->
                    textify model.key model.message
    in
        div [ class "output" ] [ text output ]
