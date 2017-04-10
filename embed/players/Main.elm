port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


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
    { players = [ Player "1" "Sam" 5 ]
    }



-- UPDATE


type Msg
    = What


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
    table [ class "table table-border table-striped" ]
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
