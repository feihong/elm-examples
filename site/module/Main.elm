import Html.App as App
import Html exposing (Html, div, text)
import Random
import Hanzi
import Bootstrap exposing (button, input)


main = App.program
  { init = init
  , view = view
  , update = update
  , subscriptions =  subscriptions
  }


-- MODEL


type alias Model = String


init : (Model, Cmd Msg)
init = ("", generateHanzi)


-- UPDATE


type Msg
  = Generate
  | NewHanzi String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Generate -> (model, generateHanzi)

    NewHanzi value -> (value, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ div [] [ text model ]
    , div [] [ button "A nice button!" ]
    , div [] [ input "Enter something witty here" ]
    ]


-- RANDOM


generateHanzi : Cmd Msg
generateHanzi = Random.generate NewHanzi Hanzi.hanzi
