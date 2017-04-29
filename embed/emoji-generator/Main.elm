port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


{-| Port for requesting random emojis.
-}
port requestEmoji : () -> Cmd msg


{-| Port for receiving random emojis.
-}
port receivedEmoji : (Emoji -> msg) -> Sub msg


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Emoji =
    { shortname : String
    , unicode : String
    , url : String
    }


type alias Model =
    { emoji : Emoji
    , displaySize : Int
    }


initialModel : Model
initialModel =
    { emoji =
        { shortname = ""
        , unicode = ""
        , url = ""
        }
    , displaySize = 128
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! [ requestEmoji () ]



-- UPDATE


type Msg
    = GotEmoji Emoji
    | Generate
    | ChangeDisplaySize Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotEmoji emoji ->
            { model | emoji = emoji } ! []

        Generate ->
            model ! [ requestEmoji () ]

        ChangeDisplaySize delta ->
            { model | displaySize = model.displaySize + delta } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    receivedEmoji GotEmoji



-- VIEWS


view : Model -> Html Msg
view model =
    div []
        [ div [ class "form-group" ]
            [ input
                [ class "form-control"
                , placeholder "Enter keyword here"
                ]
                []
            ]
        , buttons model
        , emojiView model
        ]


buttons model =
    div [ class "buttons" ]
        [ button [ class "btn btn-primary generate", onClick Generate ]
            [ text "Random emoji" ]
        , span [] [ text "Size: " ]
        , sizeBtn "-10" -10
        , sizeBtn "-1" -1
        , span [ class "size" ] [ text <| toString model.displaySize ]
        , sizeBtn "+1" 1
        , sizeBtn "+10" 10
        ]


emojiView : Model -> Html Msg
emojiView ({ emoji } as model) =
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
            , a [ href emoji.url ] [ text "Link" ]
            ]
        ]


sizeBtn : String -> Int -> Html Msg
sizeBtn label delta =
    button [ class "btn btn-default", onClick <| ChangeDisplaySize delta ]
        [ text label ]
