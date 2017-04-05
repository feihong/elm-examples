{- This is my implementation of the Emoji Translator from the ElmBridge
   tutorial:

   https://elmbridge.github.io/curriculum/

   It roughly implements the same program, but I didn't use any of their code
   and built my version pretty much from scratch. Another difference is that I
   used a native module to get around the problem in 0.18 where String.toList
   doesn't return the right result for strings containing characters outside
   of the BMP.

-}


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Emojifier exposing (emojify, textify, availableEmojis)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
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


init : ( Model, Cmd Msg )
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeMessage str ->
            { model | message = str } ! []

        SwitchMode mode ->
            { model | mode = mode } ! []

        ChangeKey char ->
            { model | key = char } ! []



-- VIEW


view : Model -> Html Msg
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


choiceView : Model -> Html Msg
choiceView model =
    let
        radio title mode =
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
    in
        div [ class "radiogroup" ]
            [ radio "Text to emoji" TextToEmoji
            , radio "Emoji to text" EmojiToText
            ]


outputView : Model -> Html Msg
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


emojiSelector : Model -> Html Msg
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
    in
        div [ class "emojis" ]
            (availableEmojis |> List.map emojiEl)
