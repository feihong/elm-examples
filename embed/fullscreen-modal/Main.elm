module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Json.Decode as Decode


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Model =
    { showModal : Bool
    }


init : ( Model, Cmd Msg )
init =
    { showModal = False } ! []



-- UPDATE


type Msg
    = NoOp
    | ToggleModal


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ToggleModal ->
            { model | showModal = not model.showModal } ! []



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ class "btn btn-primary", onClick ToggleModal ]
            [ text "Show modal" ]
        , if model.showModal then
            modalView
          else
            text ""
        ]


modalView =
    div [ class "modal-fullscreen" ]
        [ p [] [ text "You are looking at the modal now" ]
        , button [ class "btn btn-default", onClick ToggleModal ] [ text "Close" ]
        ]
