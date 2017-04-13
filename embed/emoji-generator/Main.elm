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


type alias Flags =
    { initialEmoji : String }


type alias Emoji =
    { shortname : String
    , unicode : String
    , url : String
    }


type alias Model =
    Emoji


initialModel =
    { shortname = ""
    , unicode = ""
    , url = ""
    }


init =
    initialModel ! [ requestEmoji () ]



-- UPDATE


type Msg
    = GotEmoji String
    | Generate
    | Embiggen
    | Emsmallen


update msg model =
    case msg of
        GotEmoji json ->
            let
                result =
                    decodeString emojiDecoder json

                newModel =
                    case result of
                        Ok emoji ->
                            emoji

                        Err _ ->
                            model
            in
                newModel ! []

        Generate ->
            model ! [ requestEmoji () ]

        _ ->
            model ! []


emojiDecoder =
    map3 Emoji
        (field "shortname" string)
        (field "unicode" string)
        (field "url" string)



-- SUBSCRIPTIONS


subscriptions model =
    receivedEmoji GotEmoji



-- VIEWS


view model =
    div []
        [ emojiView model
        , div []
            [ button [ class "btn btn-primary generate", onClick Generate ]
                [ text "Generate" ]
            , button [ class "btn btn-default" ] [ text "-" ]
            , button [ class "btn btn-default" ] [ text "+" ]
            ]
        ]


emojiView emoji =
    div [ class "emoji" ]
        [ div []
            [ text "Shortname: "
            , span [ class "shortname" ] [ text emoji.shortname ]
            ]
        , div []
            [ text "Unicode: "
            , span [ class "unicode" ] [ text emoji.unicode ]
            ]
        , div []
            [ text "Image: "
            , img [ src emoji.url ] []
            ]
        ]
