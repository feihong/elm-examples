import Html exposing (Html, div, p, text, button, ul, li, a)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
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
      Just <| UrlChange NewEntry "#home"

    Meat ->
      Just <| UrlChange NewEntry "#meat"

    FruitsAndVeggies ->
      Just <| UrlChange NewEntry "#fruitsandveggies"

    Grains ->
      Just <| UrlChange NewEntry "#grains"


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
  div []
    [ nav model
    , mainContent model
    ]


nav model =
  let
    navli title page = li [
        classList [
          ("active", page == model.activePage)
        ]
      ]
      [ a [ onClick <| SetActivePage page ] [ text title ]
      ]
  in
    ul [ class "nav nav-tabs" ]
      [ navli "Home" Home
      , navli "Meat" Meat
      , navli "Fruits & Veggies" FruitsAndVeggies
      , navli "Grains" Grains
      ]


mainContent : Model -> Html Msg
mainContent model =
  let
    div_ dtext =
      div [ class "main" ] [ text dtext ]
  in
    case model.activePage of
      Home ->
        div_ "This is the home page, y'all."

      Meat ->
        div_ "Doctors recommend you eat 5 lbs of meat every day."

      FruitsAndVeggies ->
        div_ "Eat fruits and vegetables until your stomatch explodes."

      Grains ->
        div_ "Meh, you don't really need to eat any grains."


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
