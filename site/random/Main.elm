import Html.App as App
import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Random


main = App.program
  { init = init
  , view = view
  , update = update
  , subscriptions =  subscriptions
  }


generate = Random.generate NewNumber (Random.int 1 100)


-- MODEL

type alias Model = Int


init : (Model, Cmd Msg)
init = (0, generate)


-- UPDATE

type Msg
  = Generate
  | NewNumber Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Generate -> (model, generate)

    NewNumber num -> (num, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW


view : Model -> Html Msg
view model =
  div [] [ text (toString model) ]
