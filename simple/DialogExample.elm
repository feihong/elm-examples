module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, on, keyCode)
import Json.Decode as Decode
import Task
import Dom
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
    , message : String
    }


init : ( Model, Cmd Msg )
init =
    { showDialog = False, message = "" } ! []



-- UPDATE


type Msg
    = NoOp
    | ToggleDialog
    | ChangeMessage String
    | SubmitMessage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ToggleDialog ->
            let
                cmds =
                    if not model.showDialog then
                        [ Dom.focus "message-input" |> Task.attempt (\_ -> NoOp) ]
                    else
                        []
            in
                { model | showDialog = not model.showDialog } ! cmds

        ChangeMessage str ->
            { model | message = str } ! []

        SubmitMessage ->
            let
                _ =
                    Debug.log "submit message" model.message
            in
                { model | showDialog = False } ! []



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
        [ div [ class "form-group" ]
            [ label [] [ text "Message" ] ]
        , input
            [ id "message-input"
            , class "form-control"
            , placeholder "Enter your message"
            , onInput ChangeMessage
            , onKeyEnter SubmitMessage
            ]
            []
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


onKeyEnter : msg -> Html.Attribute msg
onKeyEnter msg =
    let
        decoder =
            keyCode
                |> Decode.andThen
                    (\code ->
                        if code == 13 then
                            Decode.succeed msg
                        else
                            Decode.fail "not enter key"
                    )
    in
        on "keypress" decoder
