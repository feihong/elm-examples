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
view model = div []
  [ topForm
  ]



topForm = form [ class "form-horizontal" ]
  [ formGroup_
      [ label_ "Number of attendees"
      , rdiv <| [ input' { type' = "number", value = "6" } ]
      ]
  , formGroup_
      [ label_ "Tax percentage"
      , rdiv
        [ div [ class "input-group" ]
            [ input' { type' = "text", value = "9.75" }
            , div [ class "input-group-addon" ] [ text "%" ]
            ]
        ]
      ]
  , formGroup_
      [ label_ "Tip percentage"
      , rdiv
        [ div [ class "input-group" ]
            [ input' { type' = "text", value = "20" }
            , div [ class "input-group-addon" ] [ text "%" ]
            ]
        ]
      ]
  ]


label_ ltext =
  label [ class "control-label col-sm-4" ] [ text ltext ]


rdiv =
  div [ class "col-sm-8" ]


input' p =
  input [ class "form-control", type' p.type', value p.value ] []
