import Html.App as App
import Html exposing (Html, div, text)
import Random
import Char
import String
import Hanzi


main = App.program
  { init = init
  , view = view
  , update = update
  , subscriptions =  subscriptions
  }


hanzi : Random.Generator String
hanzi = Random.map (\x -> x |> Char.fromCode |> String.fromChar) (Random.int 0x4e00 0x9fff)

generateHanzi : Cmd Msg
generateHanzi = Random.generate NewHanzi hanzi


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
  div [] [ text (toString (Hanzi.add 3 9)) ]
