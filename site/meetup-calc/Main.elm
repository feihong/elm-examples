import Html.App as App
import Html exposing (Html, div, p, text, button, form, label, input)
import Html.Attributes exposing (class, type', name, value)
import Html.Events exposing (onClick)
import Bootstrap.Html exposing (colSm_, colSmOffset_, formGroup_)


main = App.program
  { init = init
  , view = view
  , update = update
  , subscriptions =  subscriptions
  }


-- MODEL


type alias Order =
  { payer : String
  , item : String
  , amount : Float
  }


type alias Model =
  { attendees : Int
  , taxPercent : Float
  , tipPercent : Float
  , orders : List Order
  }


emptyModel =
  { attendees = 0
  , taxPercent = 9.75
  , tipPercent = 20
  , orders = []
  }


init : (Model, Cmd Msg)
init = (emptyModel, Cmd.none)


-- UPDATE


type Msg
  = Generate
  | NewNumber Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    _ -> (model, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- VIEW


view : Model -> Html Msg
view model =
  form [ class "form-horizontal" ]
    [ formGroup_
        [ label_ "Number of attendees"
        , rdiv <| input' { type' = "number", value = "6" }
        ]
    ]


label_ ltext =
  label [ class "control-label col-sm-4" ] [ text ltext ]


rdiv el =
  div [ class "col-sm-8" ] [ el ]


input' p =
  input [ class "form-control", type' p.type', value p.value ] []
