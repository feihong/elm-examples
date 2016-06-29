import Html.App as App
import Html exposing (Html, div, p, text, button, form, label, input, ul, li)
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
  , price : Float
  }


type alias Model =
  { attendees : Int
  , taxPercent : Float
  , tipPercent : Float
  , orders : List Order
  }


emptyModel =
  { attendees = 6
  , taxPercent = 9.75
  , tipPercent = 20
  , orders = []
  }


testModel =
  { attendees = 6
  , taxPercent = 9.75
  , tipPercent = 20
  , orders =
    [ { payer = "Group"
      , item = "Pizza"
      , price = 12.50
      }
    , { payer = "Group"
      , item = "Garlicky blob fish fingers"
      , price = 10.20
      }
    ]
  }


init : (Model, Cmd Msg)
init = (testModel, Cmd.none)


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
  [ topForm model
  , orderList model.orders
  ]


topForm model =
  form [ class "form-horizontal" ]
    [ formGroup_
        [ label_ "Number of attendees"
        , rdiv <| [ input' { type' = "number", value = toString model.attendees } ]
        ]
    , formGroup_
        [ label_ "Tax percentage"
        , rdiv
          [ div [ class "input-group" ]
              [ input' { type' = "text", value = toString model.taxPercent }
              , div [ class "input-group-addon" ] [ text "%" ]
              ]
          ]
        ]
    , formGroup_
        [ label_ "Tip percentage"
        , rdiv
          [ div [ class "input-group" ]
              [ input' { type' = "text", value = toString model.tipPercent }
              , div [ class "input-group-addon" ] [ text "%" ]
              ]
          ]
        ]
    ]


orderList orders =
  let
    orderLi order = li []
      [ text order.payer
      , text order.item
      , text <| toString order.price
      ]
  in
    ul [] <| List.map orderLi orders


label_ ltext =
  label [ class "control-label col-sm-4" ] [ text ltext ]


rdiv =
  div [ class "col-sm-8" ]


input' p =
  input [ class "form-control", type' p.type', value p.value ] []
