{- Source:
   http://outreach.mcmaster.ca/tutorials/shapes/shapes.html
-}


module Main exposing (..)

import Color exposing (..)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Collage exposing (..)
import Element exposing (Element)


main : Html msg
main =
    Html.div
        [ style
            [ ( "margin", "2rem" )
            , ( "border", "1px dashed gray" )
            , ( "display", "inline-block" )
            ]
        ]
        [ view |> Element.toHtml ]


view : Element
view =
    collage 300
        300
        [ ngon 6 75
            |> filled red
            |> move ( -30, 0 )
        , circle 50
            |> filled clearGrey
            |> move ( 50, 10 )
        , circle 20
            |> filled niceBlue
            |> move ( 0, 120 )
        , ngon 3 50
            |> filled purple
            |> move ( -10, -100 )
            |> rotate (degrees 15)
        ]


clearGrey : Color
clearGrey =
    rgba 111 111 111 0.6


niceBlue : Color
niceBlue =
    (hsl (degrees 206) 0.57 0.63)
