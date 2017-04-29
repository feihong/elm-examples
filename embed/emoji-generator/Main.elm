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
    { emojis : List Emoji
    , displaySize : Int
    }


initialModel : Model
initialModel =
    { emojis = List.singleton (Emoji "" "" "")
    , displaySize = 128
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! [ requestEmoji () ]



-- UPDATE


type Msg
    = GotRandomEmoji Emoji
    | Generate
    | ChangeDisplaySize Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotRandomEmoji emoji ->
            { model | emojis = [ emoji ] } ! []

        Generate ->
            model ! [ requestEmoji () ]

        ChangeDisplaySize delta ->
            { model | displaySize = model.displaySize + delta } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    receivedEmoji GotRandomEmoji



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
