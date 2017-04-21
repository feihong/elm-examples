{- Source:
   http://outreach.mcmaster.ca/tutorials/animation/animation.html
-}


module Main exposing (..)

import Time exposing (Time)
import Color exposing (..)
import Html exposing (Html, div, text, input, label)
import Html.Attributes exposing (style, type_)
import Html.Events exposing (onClick)
import Collage exposing (..)
import Element exposing (Element)
import AnimationFrame


main : Program Never Model Msg
main =
    Html.program
        { init = ( { time = 0, showTime = False, animations = [] }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> AnimationFrame.times Tick
        }


type Animation
    = Pulsing
    | Circling
    | Rotating


type alias Model =
    { time : Time
    , showTime : Bool
    , animations : List Animation
    }


type Msg
    = Noop
    | Tick Time
    | ToggleAnimation Animation
    | ToggleShowTime



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            { model | time = time } ! []

        ToggleShowTime ->
            { model | showTime = not model.showTime } ! []

        ToggleAnimation animation ->
            let
                newAnimations =
                    if List.member animation model.animations then
                        List.filter ((/=) animation) model.animations
                    else
                        animation :: model.animations

                _ =
                    Debug.log "transforms" newAnimations
            in
                { model | animations = newAnimations } ! []

        Noop ->
            model ! []



-- VIEW


view : Model -> Html Msg
view ({ time } as model) =
    div [ style [ ( "margin", "2rem" ) ] ]
        [ if model.showTime then
            div [] [ Html.text <| toString time ]
          else
            Html.text ""
        , collageContainer 300
            300
            [ batman
                |> applyAnimations model.animations time
            ]
        , div []
            [ checkbox "Show time" ToggleShowTime
            , checkbox "Pulsing" <| ToggleAnimation Pulsing
            , checkbox "Circling" <| ToggleAnimation Circling
            , checkbox "Rotating" <| ToggleAnimation Rotating
            ]
        ]


collageContainer : Int -> Int -> List Form -> Html msg
collageContainer width height children =
    div
        [ style
            [ ( "border", "1px dashed gray" )
            , ( "display", "inline-block" )
            ]
        ]
        [ collage width height children
            |> Element.toHtml
        ]


checkbox : String -> msg -> Html msg
checkbox label_ msg =
    label []
        [ input [ type_ "checkbox", onClick msg ] []
        , Html.text label_
        ]


pulsing t =
    scale (abs (sin (t / 1000)))


circling t =
    move ( (50 * (sin (t / 500))), (50 * (cos (t / 500))) )


rotating t =
    rotate (5 * (sin (t / 1000)))


applyAnimations : List Animation -> Float -> Form -> Form
applyAnimations animations t form =
    let
        applyAnimation animation form =
            let
                fn =
                    case animation of
                        Pulsing ->
                            pulsing

                        Rotating ->
                            rotating

                        Circling ->
                            circling
            in
                form |> fn t
    in
        List.foldl applyAnimation form animations


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


skinColor : Color
skinColor =
    hsl 0.17 1 0.74
