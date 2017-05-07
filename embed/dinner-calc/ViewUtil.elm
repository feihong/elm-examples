module ViewUtil exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, keyCode)
import Json.Decode as Decode


icon name =
    span [ class <| "glyphicon glyphicon-" ++ name ] []


onKeyEnter : msg -> Html.Attribute msg
onKeyEnter msg =
    let
        decoder =
            keyCode
                |> Decode.andThen
                    (\code ->
                        if code == 13 then
                            Decode.succeed msg
                        else
                            Decode.fail "not enter key"
                    )
    in
        on "keypress" decoder
