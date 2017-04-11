module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (WebData)


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, fetchPlayers )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias PlayerId =
    String


type alias Player =
    { id : PlayerId
    , name : String
    , level : Int
    }


type alias Model =
    { response : WebData (List Player)
    }


initialModel =
    { response = RemoteData.Loading
    }



-- UPDATE


type Msg
    = OnFetchPlayers (WebData (List Player))


fetchPlayers =
    Http.get "/api/players/" playersDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchPlayers


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



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ nav
        , maybeList model.response
        ]


nav =
    div [ class "nav" ] [ text "Players" ]


maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success players ->
            playerList players

        RemoteData.Failure error ->
            text <| toString error


playerList : List Player -> Html Msg
playerList players =
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
