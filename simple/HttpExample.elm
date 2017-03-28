module Main exposing (..)

import Html exposing (Html, div, p, pre, text, button, code)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Http
import Task
import Json.Decode as Decode


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { content : String
    , errorMsg : String
    , version : String
    }


init : ( Model, Cmd Msg )
init =
    ( { content = "", errorMsg = "", version = "" }, fetch "elm-package.json" )



-- UPDATE


type Msg
    = Fetch String
    | FetchJson String
    | HandleResponse (Result Http.Error String)
    | HandleJsonResponse (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch url ->
            ( model, fetch url )

        FetchJson url ->
            ( model, fetchJson url )

        HandleResponse response ->
            let
                newModel =
                    case response of
                        Ok value ->
                            { model | content = value }

                        Err reason ->
                            { model | errorMsg = toString reason }
            in
                ( newModel, Cmd.none )

        HandleJsonResponse response ->
            let
                newModel =
                    case response of
                        Ok value ->
                            { model | version = value }

                        Err reason ->
                            { model | errorMsg = toString reason }
            in
                ( newModel, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text "Contents of this program's elm-package.json:" ]
        , pre [] [ text model.content ]
        , p []
            [ button [ onClick (FetchJson "elm-package.json") ]
                [ text "Get Elm version" ]
            , text "Elm version: "
            , code [] [ text model.version ]
            ]
        , p []
            [ button [ onClick (Fetch "does-not-exist.json") ]
                [ text "Make failing request" ]
            , text "Error message: "
            , code [] [ text model.errorMsg ]
            ]
        ]



-- HTTP


fetch : String -> Cmd Msg
fetch url =
    Http.send HandleResponse (Http.getString url)


fetchJson : String -> Cmd Msg
fetchJson url =
    let
        decodeElmVersion =
            Decode.at [ "elm-version" ] Decode.string

        request =
            Http.get url decodeElmVersion
    in
        Http.send HandleJsonResponse request
