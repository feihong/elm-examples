{- Source:
   http://outreach.mcmaster.ca/tutorials/shapes/shapes.html
-}


module Main exposing (..)

import Time exposing (Time)
import Color exposing (..)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Collage exposing (..)
import Element exposing (Element)


main : Program Never Model Msg
main =
    Html.program
        { init = ( { counter = 0 }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Time.every Time.millisecond Tick
        }


type alias Model =
    { counter : Int }


type Msg
    = Noop
    | Tick Time



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            { model | counter = model.counter + 1 } ! []

        Noop ->
            model ! []



-- VIEW


view : Model -> Html msg
view ({ counter } as model) =
    let
        t =
            toFloat counter
    in
        Html.div
            [ style
                [ ( "margin", "2rem" )
                , ( "border", "1px dashed gray" )
                , ( "display", "inline-block" )
                ]
            ]
            [ Html.div [] [ Html.text <| toString model.counter ]
            , collage 300 300 [ batman |> rotating t ]
                |> Element.toHtml
            ]


pulsing t =
    scale (abs (sin (t / 100)))


circling t =
    move ( (50 * (sin (t / 100))), (50 * (cos (t / 100))) )


rotating t =
    rotate (5 * (sin (t / 300)))


batman =
    group
        [ circle 50
            |> filled black
            |> move ( 0, 0 )
        , circle 50
            |> filled skinColor
            |> move ( 0, 0 )
            |> scale 0.9
        , polygon [ ( -10, 0 ), ( 0, -5 ), ( 10, 0 ), ( 3, 10 ), ( -3, 10 ) ]
            |> filled black
            |> move ( 0, -4 )
            |> scale 5
        , ngon 3 30
            |> filled black
            |> move ( 29, 35 )
            |> rotate (degrees 70)
        , ngon 3 30
            |> filled black
            |> move ( -29, 35 )
            |> rotate (degrees 110)
        , oval 40 20
            |> filled white
            |> move ( 25, 0 )
            |> rotate (degrees 30)
        , rect 45 15
            |> filled black
            |> move ( 25, 8 )
            |> rotate (degrees 20)
        , oval 40 20
            |> filled white
            |> move ( -25, 0 )
            |> rotate (degrees 150)
        , rect 45 15
            |> filled black
            |> move ( -25, 8 )
            |> rotate (degrees 160)
        , rect 20 2
            |> filled black
            |> move ( 0, -35 )
        , rect 5 2
            |> filled black
            |> move ( -12, -36 )
            |> rotate (degrees 20)
        , rect 5 2
            |> filled black
            |> move ( 12, -36 )
            |> rotate (degrees 160)
        ]


skinColor =
    hsl 0.17 1 0.74
