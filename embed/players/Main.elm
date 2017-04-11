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
import PlayerEditView


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- INIT


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
        [ div [ class "nav" ] [ text "Players" ]
        , page model
        ]


page : Model -> Html Msg
page model =
    case model.route of
        PlayersRoute ->
            playersListPage model.response

        PlayerRoute id ->
            playerEditPage model.response id

        NotFoundRoute ->
            notFoundView


playerEditPage : WebData (List Player) -> PlayerId -> Html Msg
playerEditPage response playerId =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure err ->
            text <| toString err

        RemoteData.Success players ->
            let
                maybePlayer =
                    players
                        |> List.filter (\player -> player.id == playerId)
                        |> List.head
            in
                case maybePlayer of
                    Just player ->
                        PlayerEditView.view player

                    Nothing ->
                        notFoundView


notFoundView =
    div [] [ text "Not found" ]


playersListPage : WebData (List Player) -> Html Msg
playersListPage response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure error ->
            text <| toString error

        RemoteData.Success players ->
            playersList players


playersList : List Player -> Html Msg
playersList players =
    table [ class "table table-striped table-hover players" ]
        [ thead []
            ([ "ID", "Name", "Level", "Actions" ]
                |> List.map (\name -> th [] [ text name ])
            )
        , tbody []
            (players
                |> List.map
                    (\player ->
                        tr []
                            [ td [] [ text player.id ]
                            , td [] [ text player.name ]
                            , td [] [ text <| toString player.level ]
                            , td [] [ text "?" ]
                            ]
                    )
            )
        ]
