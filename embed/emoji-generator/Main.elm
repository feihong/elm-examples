port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events exposing (onClick, onInput)
import Json.Decode as Decode


{-| Port for requesting random emojis.
-}
port requestRandomEmoji : () -> Cmd msg


{-| Port for receiving random emojis.
-}
port receivedRandomEmoji : (Emoji -> msg) -> Sub msg


port requestEmojisWithKeyword : String -> Cmd msg


port receivedEmojis : (List Emoji -> msg) -> Sub msg


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
    { keyword : String
    , emojis : List Emoji
    , displaySize : Int
    }


initialModel : Model
initialModel =
    { keyword = ""
    , emojis = List.singleton (Emoji "" "" "")
    , displaySize = 128
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! [ requestRandomEmoji () ]



-- UPDATE


type Msg
    = GotRandomEmoji Emoji
    | GotEmojis (List Emoji)
    | Generate
    | ChangeDisplaySize Int
    | ChangeKeyword String
    | SubmitKeyword


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotRandomEmoji emoji ->
            { model | emojis = [ emoji ] } ! []

        GotEmojis emojis ->
            { model | emojis = emojis } ! []

        Generate ->
            model ! [ requestRandomEmoji () ]

        ChangeDisplaySize delta ->
            { model | displaySize = model.displaySize + delta } ! []

        ChangeKeyword str ->
            { model | keyword = str } ! []

        SubmitKeyword ->
            let
                _ =
                    Debug.log "submit" model.keyword
            in
                model ! [ requestEmojisWithKeyword model.keyword ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receivedRandomEmoji GotRandomEmoji
        , receivedEmojis GotEmojis
        ]



-- VIEWS


view : Model -> Html Msg
view model =
    div []
        [ div [ class "form-group" ]
            [ input
                [ class "form-control"
                , placeholder "Enter keyword here"
                , value model.keyword
                , onInput <| ChangeKeyword
                , onKeyEnter SubmitKeyword
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
emojiView ({ emojis } as model) =
    let
        th_ str =
            th [] [ text str ]

        tr_ { shortname, unicode, url } =
            tr []
                [ td [ class "shortname" ] [ text shortname ]
                , td [ style [ ( "fontSize", (toString model.displaySize) ++ "px" ) ] ]
                    [ text unicode ]
                , td [] [ img [ src url, width model.displaySize ] [] ]
                , td [] [ a [ href url ] [ text "Link" ] ]
                ]
    in
        table [ class "table table-bordered" ]
            [ thead []
                [ tr [] ([ "Shortname", "Unicode", "Image", "URL" ] |> List.map th_)
                ]
            , tbody [] (emojis |> List.map tr_)
            ]


sizeBtn : String -> Int -> Html Msg
sizeBtn label delta =
    button [ class "btn btn-default", onClick <| ChangeDisplaySize delta ]
        [ text label ]


onKeyEnter : msg -> Html.Attribute msg
onKeyEnter msg =
    let
        decoder =
            Events.keyCode
                |> Decode.andThen
                    (\code ->
                        if code == 13 then
                            Decode.succeed msg
                        else
                            Decode.fail "not enter key"
                    )
    in
        Events.on "keypress" decoder
