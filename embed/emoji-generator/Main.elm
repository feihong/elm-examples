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
    { emoji : Emoji
    , displaySize : Int
    }


initialModel =
    { emoji =
        { shortname = ""
        , unicode = ""
        , url = ""
        }
    , displaySize = 100
    }


init =
    initialModel ! [ requestEmoji () ]



-- UPDATE


type Msg
    = GotEmoji String
    | Generate
    | ChangeDisplaySize Int


update msg model =
    case msg of
        GotEmoji json ->
            let
                result =
                    decodeString emojiDecoder json

                newModel =
                    case result of
                        Ok emoji ->
                            { model | emoji = emoji }

                        Err _ ->
                            model
            in
                newModel ! []

        Generate ->
            model ! [ requestEmoji () ]

        ChangeDisplaySize delta ->
            { model | displaySize = model.displaySize + delta } ! []


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
            , sizeBtn "-10" -10
            , sizeBtn "-1" -1
            , span [] [ text <| toString model.displaySize ]
            , sizeBtn "+1" 1
            , sizeBtn "+10" 10
            ]
        ]


emojiView model =
    let
        emoji =
            model.emoji
    in
        div [ class "emoji" ]
            [ div []
                [ text "Shortname: "
                , span [ class "shortname" ] [ text emoji.shortname ]
                ]
            , div []
                [ text "Unicode: "
                , span
                    [ class "unicode"
                    , style [ ( "fontSize", (toString model.displaySize) ++ "px" ) ]
                    ]
                    [ text emoji.unicode ]
                ]
            , div []
                [ text "Image: "
                , img [ src emoji.url, width model.displaySize ] []
                ]
            ]


sizeBtn label delta =
    button [ class "btn btn-default", onClick <| ChangeDisplaySize delta ]
        [ text label ]
