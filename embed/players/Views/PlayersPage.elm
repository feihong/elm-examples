module Views.PlayersPage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import RemoteData exposing (WebData)
import Models exposing (Player)
import Routing exposing (playerPath)


page : WebData (List Player) -> Html msg
page response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure error ->
            text <| toString error

        RemoteData.Success players ->
            playersList players


playersList : List Player -> Html msg
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
                            , td [] [ editBtn player ]
                            ]
                    )
            )
        ]


editBtn : Player -> Html msg
editBtn player =
    a [ href <| playerPath player.id ]
        [ span [ class "glyphicon glyphicon-pencil" ] []
        ]
