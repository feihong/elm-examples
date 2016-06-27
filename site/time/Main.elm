import Html.App as App
import Html exposing (Html, div, p, text)
import Time exposing (Time)


main = App.program
  { init = init
  , view = view
  , update = update
  , subscriptions =  subscriptions
  }


-- MODEL


type alias Model =
  { counter : Int }


init : (Model, Cmd Msg)
init = ({ counter = 0 }, Cmd.none)


-- UPDATE


type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update (Tick newTime) model =
  ({ model | counter = model.counter + 1 }, Cmd.none)

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 500 Tick


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ p [] [ model.counter |> toString |> text ] ]
