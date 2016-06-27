import Html.App
import Html exposing (Html, div, p, pre, text, button)
import Http
import Task


main = Html.App.program
  { init = init
  , view = view
  , update = update
  , subscriptions =  subscriptions
  }


-- MODEL


type alias Model =
  { content : String
  , errorMesg : String }


init : (Model, Cmd Msg)
init = (Model "" "", fetch)


-- UPDATE


type Msg
  = Fetch
  | Success String
  | Failure Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Fetch ->
      (model, fetch)

    Success result ->
      ({ model | content = result }, Cmd.none)

    Failure error ->
      ({ model | errorMesg = toString error }, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ p [] [ text "Contents of this program's elm-package.json:" ]
    , pre [] [ text model.content ]
    ]


-- HTTP


fetch : Cmd Msg
fetch =
  Task.perform Failure Success (Http.getString "elm-package.json")
