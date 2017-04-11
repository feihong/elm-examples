module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Decode
import RemoteData exposing (WebData)


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
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
    { players : List Player
    }


initialModel =
    { players =
        [ Player "1" "Sam" 5
        , Player "2" "Ellie" 6
        ]
    }



-- UPDATE


type Msg
    = OnFetchPlayers (WebData (List Player))


fetchPlayers url =
    url


update msg model =
    model ! []



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ nav
        , playerList model.players
        ]


nav =
    div [ class "nav" ] [ text "Players" ]


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
