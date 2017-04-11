module Main exposing (..)

import Html exposing (..)
import Navigation exposing (Location)
import Models exposing (..)
import Msgs exposing (..)
import Routing exposing (parseLocation)
import RemoteData
import Views.PlayersPage
import Views.PlayerPage
import Commands


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
        initialModel currentRoute ! [ Commands.fetchPlayers ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchPlayers response ->
            { model | response = response } ! []

        OnLocationChange location ->
            { model | route = parseLocation location } ! []

        ChangeLevel player howMuch ->
            let
                updatedPlayer =
                    { player | level = player.level + howMuch }
            in
                model ! [ Commands.savePlayerCmd updatedPlayer ]

        OnPlayerSave (Ok player) ->
            { model | response = updatePlayer model player } ! []

        OnPlayerSave (Err error) ->
            model ! []


updatePlayer model updatedPlayer =
    let
        updatePlayerList players =
            players
                |> List.map
                    (\player ->
                        if player.id == updatedPlayer.id then
                            updatedPlayer
                        else
                            player
                    )
    in
        model.response
            |> RemoteData.map updatePlayerList



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


notFoundView : Html msg
notFoundView =
    div [] [ text "Not found" ]
