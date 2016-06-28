module Bootstrap exposing (button, input)

import Html as Htm
import Html.Attributes exposing (class, type', placeholder)


button title =
  Htm.button [ class "btn btn-default" ] [ Htm.text title ]


input placeHolder =
  Htm.input [ type' "text", class "form-control", placeholder placeHolder ] []
