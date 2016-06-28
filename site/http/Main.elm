import Html.App
import Html exposing (Html, div, p, pre, text, button, code)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Http
import Task
import Json.Decode as Decode


main = Html.App.program
  { init = init
  , view = view
  , update = update
  , subscriptions =  subscriptions
  }


-- MODEL


type alias Model =
  { content : String
  , errorMsg : String
  , version : String
  }


init : (Model, Cmd Msg)
init = (Model "" "" "", fetch "elm-package.json")


-- UPDATE


type Msg
  = Fetch String
  | Success String
  | FetchJson String
  | SuccessJson String
  | Failure Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Fetch url ->
      (model, fetch url)

    Success result ->
      ({ model | content = result }, Cmd.none)

    FetchJson url ->
      (model, fetchJson url)

    SuccessJson result ->
      ({ model | version = result }, Cmd.none)

    Failure error ->
      ({ model | errorMsg = toString error }, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- VIEW


btnClass = class "btn btn-default"


view : Model -> Html Msg
view model =
  div []
    [ p [] [ text "Contents of this program's elm-package.json:" ]
    , pre [] [ text model.content ]
    , button [ btnClass, onClick (FetchJson "elm-package.json") ] [ text "Get Elm version" ]
    , p []
      [ text "Elm version: "
      , code [] [ text model.version ]
      ]
    , button [ btnClass, onClick (Fetch "does-not-exist.json") ] [ text "Make failing request" ]
    , p []
      [ text "Error message:"
      , code [] [ text model.errorMsg ]
      ]
    ]


-- HTTP


fetch : String -> Cmd Msg
fetch url =
  Task.perform Failure Success (Http.getString url)


fetchJson : String -> Cmd Msg
fetchJson url =
  let
    decodeElmVersion = Decode.at [ "elm-version" ] Decode.string
  in
    Task.perform Failure SuccessJson (Http.get decodeElmVersion url)