module Main exposing (..)

import Html exposing (Html, div, p, ul, li, button, text)
import Html.Events exposing (onClick)
import Time exposing (Time)
import Char


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { counter : Int
    , active : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { counter = 0, active = True }, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | Toggle


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Toggle ->
            ( { model | active = not model.active }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.active then
        Time.every 500 Tick
    else
        Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        ordinals =
            [ 65, 3000, 0x0600, 0x4E00 ]
                |> List.map (\x -> model.counter + x)
    in
        div []
            [ p []
                [ text "Counter: "
                , text <| toString model.counter
                ]
            , button [ onClick Toggle ]
                [ text <|
                    if model.active then
                        "Pause"
                    else
                        "Go"
                ]
            , p [] [ text "Letters:" ]
            , ul [] (List.map letterLi ordinals)
            ]


letterLi : Int -> Html Msg
letterLi ordinal =
    let
        getLetter ordinal =
            ordinal |> Char.fromCode |> String.fromChar
    in
        li [] [ text <| getLetter ordinal ]
