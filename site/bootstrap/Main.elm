import Html exposing (Html, div, p, text)
import Html.Attributes exposing(class)
import Bootstrap.Html exposing (row_, colSm_, colSmOffset_)

main = div [ class "grid" ]
  [ row_
      [ colSm_ 6 2 [ text "6 2" ]
      , colSm_ 6 10 [ text "6 10"]
      ]
  , row_
      [ colSm_ 6 4 [ text "6 4" ]
      , colSm_ 6 8 [ text "6 8"]
      ]
  , row_
      [ colSm_ 6 6 [ text "6 6" ]
      , colSm_ 6 6 [ text "6 6"]
      ]
  , row_
      [ colSm_ 6 8 [ text "6 8" ]
      , colSm_ 6 4 [ text "6 4"]
      ]
  , row_
      [ colSm_ 6 10 [ text "6 10" ]
      , colSm_ 6 2 [ text "6 2"]
      ]
  ]
