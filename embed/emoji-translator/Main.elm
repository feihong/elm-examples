module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Emojifier exposing (emojify)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { message : String
    , key : Char
    }


init =
    ( { message = "ABCD, WXYZ; abcd, wxyz!"
      , key = '😀'
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeMessage String


update msg model =
    case msg of
        ChangeMessage str ->
            { model | message = str } ! []



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
            ]
            []
        , div [ class "output" ]
            [ text <| emojify model.key model.message
            ]
        ]
