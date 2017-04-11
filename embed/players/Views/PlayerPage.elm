module Views.PlayerPage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
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


view : Player -> Html msg
view player =
    div [ class "player" ]
        [ h3 [] [ backBtn, text player.name ]
        , div [ class "edit" ]
            [ span [ class "level" ]
                [ text "Level "
                , text <| toString player.level
                ]
            , levelButton Decrement
            , levelButton Increment
            ]
        ]


backBtn =
    a
        [ class "btn btn-default back"
        , href playersPath
        ]
        [ span [ class "glyphicon glyphicon-chevron-left" ] []
        ]


levelButton buttonType =
    let
        label =
            case buttonType of
                Decrement ->
                    "-"

                Increment ->
                    "+"
    in
        button [ class "btn btn-default" ] [ text label ]
