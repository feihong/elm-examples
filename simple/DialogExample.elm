module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events exposing (onInput, onClick)
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
    | OpenDialog
    | CloseDialog
    | ChangeMessage String
    | SubmitMessage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        OpenDialog ->
            { model | showDialog = True }
                ! [ Dom.focus "message-input" |> Task.attempt (\_ -> NoOp) ]

        CloseDialog ->
            { model | showDialog = False } ! []

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
            , onClick OpenDialog
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
    { closeMessage = Just CloseDialog
    , containerClass = Nothing
    , header = Just <| h4 [ class "modal-title" ] [ text "A cool dialog" ]
    , body = Just <| dialogBody
    , footer = Just <| dialogFooter
    }


dialogBody =
    div [ onKeyEsc CloseDialog ]
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
            , onClick <| CloseDialog
            ]
            [ text "Delete" ]
        , button [ class "btn btn-default", onClick CloseDialog ]
            [ text "Cancel" ]
        , button
            [ class "btn btn-primary"
            , onClick CloseDialog
            ]
            [ text "Save" ]
        ]


onKeyEnter : msg -> Html.Attribute msg
onKeyEnter =
    onKeyPressHandler <| (==) 13


onKeyEsc : msg -> Html.Attribute msg
onKeyEsc =
    onKeyPressHandler <| (==) 27


onKeyPressHandler : (Int -> Bool) -> msg -> Html.Attribute msg
onKeyPressHandler keyCodePred msg =
    let
        decoder =
            Events.keyCode
                |> Decode.andThen
                    (\code ->
                        if keyCodePred code then
                            Decode.succeed msg
                        else
                            Decode.fail "not enter key"
                    )
    in
        Events.on "keypress" decoder
