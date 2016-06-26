import Html exposing (Html, div, p, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Html.App exposing (beginnerProgram)

main = beginnerProgram { model = model, view = view, update = update }

-- MODEL

type alias Model = String

model: String
model = "Hello World"

-- UPDATE

type Msg = English | German | Chinese

update : Msg -> Model -> Model
update action model =
  case action of
    English ->
      "Hello World"

    German ->
      "Hallo Welt"

    Chinese ->
      "你好世界"

-- VIEW

view : Model -> Html Msg
view model  =
  div [] [
    p [] [text model],
    button [ class "btn btn-default", onClick English ] [text "English"],
    button [ class "btn btn-default", onClick German ] [text "German"],
    button [ class "btn btn-default", onClick Chinese ] [text "Chinese"]
  ]
