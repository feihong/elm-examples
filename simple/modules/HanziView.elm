module HanziView exposing (hanziView)

import Html exposing (Html, div, text, button)
import Html.Attributes
import Html.Events exposing (onClick)
import Css exposing (px, color, fontSize, margin, textShadow3)
import Css.Colors exposing (..)


rem_ : Float -> Css.Rem
rem_ =
    Css.rem


styles : List Css.Mixin -> Html.Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style


hanziStyles : Html.Attribute msg
hanziStyles =
    styles
        [ color purple
        , fontSize (rem_ 8)
        , textShadow3 (px 3) (px 5) silver
        ]


hanziView : String -> msg -> Html msg
hanziView hanzi generateMsg =
    div [ styles [ margin (rem_ 1) ] ]
        [ div [ hanziStyles ] [ text hanzi ]
        , button [ onClick generateMsg ] [ text "Generate" ]
        ]
