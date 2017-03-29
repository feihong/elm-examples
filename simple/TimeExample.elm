module Main exposing (..)

import Html exposing (Html, div, p, ul, li, text)
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
    { counter : Int }


init : ( Model, Cmd Msg )
init =
    ( { counter = 0 }, Cmd.none )



-- UPDATE


type Msg
    = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update (Tick newTime) model =
    ( { model | counter = model.counter + 1 }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 500 Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        ordinals =
            [ 65, 0x0600, 0x4E00 ]
                |> List.map (\x -> model.counter + x)
    in
        div []
            [ p []
                [ text "Counter: "
                , text <| toString model.counter
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
