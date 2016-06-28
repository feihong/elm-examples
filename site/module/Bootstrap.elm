module Bootstrap exposing (button, input)

import Html as Htm
import Html.Attributes exposing (class, type', placeholder)


button : String -> Htm.Html a
button title =
  Htm.button [ class "btn btn-default" ] [ Htm.text title ]


input : String -> Htm.Html a
input placeHolder =
  Htm.input [ type' "text", class "form-control", placeholder placeHolder ] []
