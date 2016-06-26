import Html exposing (Html, div, p, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Html.App exposing (beginnerProgram)

main = beginnerProgram { model = model, view = view, update = update }

-- MODEL

type alias Model = String

model: String
model = "Hello World!"

-- UPDATE

type Msg = ChangeGreeting

update : Msg -> Model -> Model
update action model =
  case action of
    ChangeGreeting ->
      "Goodbye Universe"

-- VIEW

view : Model -> Html Msg
view model  =
  div [] [
    p [] [text model],
    button [ class "btn btn-default", onClick ChangeGreeting ] [text "Click me!"]
  ]
