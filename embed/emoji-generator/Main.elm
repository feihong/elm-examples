port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode exposing (..)


{-| Port for requesting random emojis.
-}
port requestEmoji : () -> Cmd msg


{-| Port for receive random emojis.
-}
port receivedEmoji : (String -> msg) -> Sub msg


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias EmojiEntry =
    { shortname : String
    , unicode : String
    , url : String
    }


type Model
    = Empty
    | Emoji EmojiEntry


init =
    Empty ! [ requestEmoji () ]



-- UPDATE


type Msg
    = GotEmoji String
    | Generate


update msg model =
    case msg of
        GotEmoji json ->
            let
                result =
                    decodeString emojiDecoder json

                model =
                    case result of
                        Ok emoji ->
                            Emoji emoji

                        Err _ ->
                            Empty
            in
                model ! []

        Generate ->
            model ! [ requestEmoji () ]


emojiDecoder =
    map3 EmojiEntry
        (field "shortname" string)
        (field "unicode" string)
        (field "url" string)



-- SUBSCRIPTIONS


subscriptions model =
    receivedEmoji GotEmoji



-- VIEWS


view model =
    div []
        [ case model of
            Empty ->
                div [] []

            Emoji entry ->
                emojiView entry
        , button [ class "btn btn-primary", onClick Generate ]
            [ text "Generate" ]
        ]


emojiView entry =
    div [ class "emoji" ]
        [ div []
            [ text "Shortname: "
            , span [ class "shortname" ] [ text entry.shortname ]
            ]
        , div []
            [ text "Unicode: "
            , span [ class "unicode" ] [ text entry.unicode ]
            ]
        , div []
            [ text "Image: "
            , img [ src entry.url ] []
            ]
        ]
