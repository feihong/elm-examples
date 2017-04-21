{- Try changing the type of the input to "number" and see how that causes the
   value sent to the ChangeTaxPercent message to always be an empty string.
-}


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Model =
    { name : String }


initModel =
    { name = "Logan" }


choices =
    [ "Sophia", "Bolivar", "Logan", "Coolio", "Lion-O", "Starscream" ]



-- UPDATE


type Msg
    = NoOp
    | ChangeName String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeName str ->
            let
                _ =
                    Debug.log "change name" str
            in
                { model | name = str } ! []

        NoOp ->
            model ! []



-- VIEW


view : Model -> Html Msg
view model =
    let
        choices_ =
            ( "", "Select name" )
                :: ( "line", "-----" )
                :: (List.map (\name -> ( name, name )) choices)
    in
        div [ style [ ( "padding", "1rem" ) ] ]
            [ div []
                [ select
                    [ value model.name
                    , onInput ChangeName
                    ]
                    (List.map nameOption choices_)
                ]
            ]


nameOption ( value_, title ) =
    option
        [ value value_
        , disabled <| value_ == "line"
        ]
        [ text title ]
