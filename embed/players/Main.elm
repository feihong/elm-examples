module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Models exposing (..)
import Msgs exposing (..)
import Routing exposing (parseLocation)
import Views.PlayersPage
import Views.PlayerPage


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- INIT


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        initialModel currentRoute ! [ fetchPlayers ]



-- UPDATE


fetchPlayers : Cmd Msg
fetchPlayers =
    Http.get "/api/players/" playersDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchPlayers


playersDecoder : Decode.Decoder (List Player)
playersDecoder =
    let
        playerDecoder =
            decode Player
                |> required "id" Decode.string
                |> required "name" Decode.string
                |> required "level" Decode.int
    in
        Decode.list playerDecoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchPlayers response ->
            { model | response = response } ! []

        OnLocationChange location ->
            { model | route = parseLocation location } ! []



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Players" ]
        , page model
        ]


page : Model -> Html Msg
page model =
    case model.route of
        PlayersRoute ->
            Views.PlayersPage.page model.response

        PlayerRoute id ->
            Views.PlayerPage.page model.response id

        NotFoundRoute ->
            notFoundView


notFoundView =
    div [] [ text "Not found" ]
