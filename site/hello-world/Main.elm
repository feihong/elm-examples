import Html exposing (Html, div, p, text, button)
import Html.Attributes exposing (classList)
import Html.Events exposing (onClick)
import Html.App exposing (beginnerProgram)


main = beginnerProgram { model = model, view = view, update = update }

-- MODEL

defaultValue = "Hello World"

choices = [
  ("English", defaultValue),
  ("German", "Hallo Welt"),
  ("Chinese", "你好世界"),
  ("Japanese", "こんにちは世界"),
  ("Esperanto", "Saluton mondo") ]


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
update (CurrentGreeting greeting) model =
  { model | greeting = greeting }

-- VIEW

view : Model -> Html Msg
view model  =
  let
    languageButtons = List.map (languageButton greeting) choices
  in
    div [] [
      p [] [ text model.greeting ],
      div [] languageButtons
    ]


languageButton : String -> (String, String) -> Html Msg
languageButton greeting (language, value) =
  button [
    classList [
      ("btn", True),
      ("btn-default", True),
      ("btn-info", greeting == value)
    ]
    , onClick (CurrentGreeting value)
  ] [ text language ]
