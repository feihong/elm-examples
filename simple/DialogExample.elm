module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Json.Decode as Decode
import Dialog
import Util


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
    { showDialog : Bool
    }


init : ( Model, Cmd Msg )
init =
    { showDialog = False } ! []



-- UPDATE


type Msg
    = NoOp
    | ToggleDialog


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ToggleDialog ->
            { model | showDialog = not model.showDialog } ! []



-- VIEW


view : Model -> Html Msg
view model =
    div [ style [ ( "margin", "2rem" ) ] ]
        [ Util.bootstrap
        , button
            [ class "btn btn-primary"
            , onClick ToggleDialog
            ]
            [ text "Open dialog" ]
        , Dialog.view
            (if model.showDialog then
                Just <| dialogConfig
             else
                Nothing
            )
        ]


dialogConfig =
    { closeMessage = Just ToggleDialog
    , containerClass = Nothing
    , header = Just <| h4 [ class "modal-title" ] [ text "Edit book" ]
    , body = Just <| dialogBody
    , footer = Just <| dialogFooter
    }


dialogBody =
    div []
        [ text "body"
        ]


dialogFooter =
    div []
        [ button
            [ class "btn btn-danger pull-left"
            , onClick <| ToggleDialog
            ]
            [ text "Delete" ]
        , button [ class "btn btn-default", onClick ToggleDialog ]
            [ text "Cancel" ]
        , button
            [ class "btn btn-primary"
            , onClick ToggleDialog
            ]
            [ text "Save" ]
        ]
