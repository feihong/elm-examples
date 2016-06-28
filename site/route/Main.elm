import Html exposing (Html, div, p, text, button)
import Html.Attributes exposing (class)
import Navigation exposing (Location)
import RouteUrl exposing (UrlChange, HistoryEntry(NewEntry))


main : Program Never
main =
    RouteUrl.program
      { delta2url = delta2url
      , location2messages = location2messages
      , init = init
      , update = update
      , view = view
      , subscriptions = subscriptions
      }


-- ROUTING


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
  case current.activePage of
    Home ->
      Just <| UrlChange NewEntry "/#home"

    Meat ->
      Just <| UrlChange NewEntry "/#meat"

    FruitsAndVeggies ->
      Just <| UrlChange NewEntry "/#fruitsandveggies"

    Grains ->
      Just <| UrlChange NewEntry "/#grains"


location2messages : Location -> List Msg
location2messages location =
  case location.hash of
    "#meat" ->
      [ SetActivePage Meat ]

    "#fruitsandveggies" ->
      [ SetActivePage FruitsAndVeggies ]

    "#grains" ->
      [ SetActivePage Grains ]

    _ ->
      [ SetActivePage Home ]


-- MODEL


type Page
  = Home
  | Meat
  | FruitsAndVeggies
  | Grains


type alias Model =
  { activePage : Page }


init : (Model, Cmd Msg)
init = (Model Home, Cmd.none)


-- UPDATE


type Msg
  = SetActivePage Page


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetActivePage page -> ({ model | activePage = page }, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  div [] [ text "Hello" ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
