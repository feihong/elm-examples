{- Source:
   http://outreach.mcmaster.ca/tutorials/shapes/shapes.html
-}


module Main exposing (..)

import Color exposing (..)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Collage exposing (collage, ngon, filled, move)
import Element exposing (Element)


main : Html msg
main =
    Html.div
        [ style
            [ ( "padding", "2rem" )
            , ( "border", "1px dashed gray" )
            ]
        ]
        [ view |> Element.toHtml
        ]


view : Element
view =
    collage 300
        300
        [ ngon 4 75
            |> filled red
            |> move ( -10, 0 )
        , ngon 5 50
            |> filled clearGrey
            |> move ( 50, 10 )
        ]


clearGrey : Color
clearGrey =
    rgba 111 111 111 0.6
