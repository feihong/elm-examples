{- Source:
   http://outreach.mcmaster.ca/tutorials/shapes/shapes.html
-}


module Main exposing (..)

import Time exposing (Time)
import Color exposing (..)
import Html exposing (Html, div, text, input, label)
import Html.Attributes exposing (style, type_)
import Html.Events exposing (onClick)
import Collage exposing (..)
import Element exposing (Element)


main : Program Never Model Msg
main =
    Html.program
        { init = ( Model 0 [], Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Time.every 10 Tick
        }


type Transform
    = Pulsing
    | Circling
    | Rotating


type alias Model =
    { counter : Int
    , transforms : List Transform
    }


type Msg
    = Noop
    | Tick Time
    | ToggleTransform Transform



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            { model | counter = model.counter + 1 } ! []

        ToggleTransform transform ->
            let
                newTransforms =
                    if List.member transform model.transforms then
                        List.filter ((==) transform) model.transforms
                    else
                        transform :: model.transforms
            in
                { model | transforms = newTransforms } ! []

        Noop ->
            model ! []



-- VIEW


view : Model -> Html Msg
view ({ counter } as model) =
    let
        t =
            toFloat counter
    in
        div [ style [ ( "margin", "2rem" ) ] ]
            [ div [] [ Html.text <| toString model.counter ]
            , canvasContainer
                [ collage 300
                    300
                    [ batman
                        |> applyTranforms model.transforms t
                    ]
                    |> Element.toHtml
                ]
            , div []
                [ checkbox "Pulsing" Pulsing
                , checkbox "Circling" Circling
                , checkbox "Rotating" Rotating
                ]
            ]


canvasContainer children =
    div
        [ style
            [ ( "border", "1px dashed gray" )
            , ( "display", "inline-block" )
            ]
        ]
        children


checkbox label_ transform =
    label []
        [ input [ type_ "checkbox", onClick <| ToggleTransform transform ] []
        , Html.text label_
        ]


pulsing t =
    scale (abs (sin (t / 100)))


circling t =
    move ( (50 * (sin (t / 100))), (50 * (cos (t / 100))) )


rotating t =
    rotate (5 * (sin (t / 300)))


applyTranforms : List Transform -> Float -> Form -> Form
applyTranforms transforms t form =
    let
        applyTransform transform form =
            let
                fn =
                    case transform of
                        Pulsing ->
                            pulsing

                        Rotating ->
                            rotating

                        Circling ->
                            circling
            in
                form |> fn t
    in
        List.foldl applyTransform form transforms


batman : Form
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
