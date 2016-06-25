import Html exposing (div, p, text, button)
import Html.Attributes exposing (class)

main =
  div [] [
    p [] [text "Hello World!"],
    button [class "btn btn-default"] [text "Click me!"]
  ]
