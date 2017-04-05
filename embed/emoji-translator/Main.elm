module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Emojifier exposing (emojify, textify, availableEmojis)


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
    ( { message =
            "ABCD, WXYZ; abcd, wxyz!"
            --   { message = "😀😁😂😃"
      , key = '😀'
      , mode = TextToEmoji
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeMessage String
    | SwitchMode TranslationMode
    | ChangeKey Char


update msg model =
    case msg of
        ChangeMessage str ->
            { model | message = str } ! []

        SwitchMode mode ->
            { model | mode = mode } ! []

        ChangeKey char ->
            { model | key = char } ! []



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
            , autofocus True
            ]
            []
        , choiceView model
        , outputView model
        , hr [] []
        , h2 [] [ text "Select your key" ]
        , emojiSelector model
        ]


choiceView model =
    div [ class "radiogroup" ]
        [ radio "Text to emoji" TextToEmoji model
        , radio "Emoji to text" EmojiToText model
        ]


radio title mode model =
    label
        []
        [ input
            [ type_ "radio"
            , name "translation-mode"
            , checked <| model.mode == mode
            , onClick <| SwitchMode mode
            ]
            []
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


emojiSelector model =
    let
        emojiEl char =
            div
                [ classList
                    [ ( "selected", model.key == char )
                    ]
                , onClick <| ChangeKey char
                ]
                [ text <| String.fromList [ char ] ]

        emojiEls =
            availableEmojis
                |> List.map emojiEl
    in
        div [ class "emojis" ] emojiEls
