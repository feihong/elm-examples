module PlayerEditView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Msgs exposing (..)
import Models exposing (Player)


type ButtonType
    = Decrement
    | Increment


view : Player -> Html msg
view player =
    div [ class "player" ]
        [ h3 [] [ text player.name ]
        , div []
            [ span [ class "level" ]
                [ text "Level "
                , text <| toString player.level
                ]
            , levelButton Decrement
            , levelButton Increment
            ]
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
