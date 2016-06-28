import Html exposing (Html, div, p, text, form, label, input, button)
import Html.Attributes exposing(class, type', name)
import Html.Shorthand exposing (div_, h2_)
import Bootstrap.Html exposing (row_, colSm_, colSmOffset_, formGroup_)

main = div_
  [ h2_ "Responsive grid system"
  , grid
  , h2_ "Forms"
  , bootstrapForm
  ]


grid = div [ class "grid" ]
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


bootstrapForm = form []
  [ formGroup_
      [ label [] [ text "Username" ]
      , input [ name "username", class "form-control" ] []
      ]
  , formGroup_
      [ label [] [ text "Password" ]
      , input [ name "password", class "form-control", type' "password" ] []
      ]
  , checkbox "coolio" "Check me out"
  , btnDefault "submit" "Submit"
  ]


checkbox cbxName cbxText =
  div [ class "checkbox" ]
    [ label []
      [ input [ name cbxName, type' "checkbox" ] []
      , text cbxText
      ]
    ]

btnDefault btnType label =
  button [ class "btn btn-default", type' btnType ] [ text label ]
