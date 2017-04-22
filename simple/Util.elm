module Util exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


bootstrap : Html msg
bootstrap =
    node "link"
        [ href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
        , rel "stylesheet"
        ]
        []
