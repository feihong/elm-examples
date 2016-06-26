import Html exposing (Html, div, p, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Html.App exposing (beginnerProgram)


main = beginnerProgram { model = model, view = view, update = update }

-- MODEL

defaultValue = "Hello World"

choices = [
  ("English", defaultValue),
  ("German", "Hallo Welt"),
  ("Chinese", "你好世界") ]


type alias Model =
  { greeting : String
  , choices : List (String, String)
  }

model: Model
model =
  { greeting = defaultValue
  , choices = choices
  }

-- UPDATE

type Msg = CurrentGreeting String

update : Msg -> Model -> Model
update action model =
  case action of
    CurrentGreeting greeting ->
      { model | greeting = greeting }

-- VIEW

view : Model -> Html Msg
view model  =
  div []
    (p [] [ text model.greeting ] :: languageButtons model.choices)

languageButtons : List (String, String) -> List (Html Msg)
languageButtons choices =
  List.map languageButton choices

languageButton : (String, String) -> Html Msg
languageButton (language, value) =
  button [ class "btn btn-default", onClick (CurrentGreeting value) ] [ text language ]
