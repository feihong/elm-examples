module Main exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (Html)
import Html.Attributes


main : Html msg
main =
    Html.div
        [ Html.Attributes.style
            [ ( "margin", "2rem" )
            , ( "border", "1px dashed gray" )
            , ( "display", "inline-block" )
            , ( "width", "400px" )
            ]
        ]
        [ view ]


view : Html msg
view =
    svg
        [ version "1.1"
        , x "0"
        , y "0"
        , viewBox "0 0 300 300"
        ]
        [ polygon [ fill "#F0AD00", points "161.649,152.782 231.514,82.916 91.783,82.916" ]
            []
        , circle [ fill "purple", cx "0", cy "0", r "80" ] []
        ]
