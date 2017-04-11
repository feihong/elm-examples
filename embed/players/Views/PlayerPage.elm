module Views.PlayerPage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData)
import Models exposing (Player, PlayerId)
import Msgs exposing (..)
import Routing exposing (playersPath)


type ButtonType
    = Decrement
    | Increment


page : WebData (List Player) -> PlayerId -> Html Msg
page response playerId =
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
                        view player

                    Nothing ->
                        div []
                            [ text <| "Player " ++ playerId ++ " was not found" ]


view : Player -> Html Msg
view player =
    div [ class "player" ]
        [ div [ class "nav" ] [ backBtn, text player.name ]
        , div [ class "edit" ]
            [ span [ class "level" ]
                [ text "Level "
                , text <| toString player.level
                ]
            , levelButton Decrement player
            , levelButton Increment player
            ]
        ]


backBtn =
    a
        [ class "btn btn-default back"
        , href playersPath
        ]
        [ span [ class "glyphicon glyphicon-chevron-left" ] []
        ]


levelButton buttonType player =
    let
        ( icon, value ) =
            case buttonType of
                Decrement ->
                    ( "minus-sign", -1 )

                Increment ->
                    ( "plus-sign", 1 )
    in
        button
            [ class "btn btn-default"
            , onClick <| ChangeLevel player value
            ]
            [ span [ class <| "glyphicon glyphicon-" ++ icon ] [] ]
