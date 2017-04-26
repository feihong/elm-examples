module ViewUtil exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Msg exposing (..)


ratingsSelect value_ =
    select
        [ class "form-control"
        , value value_
        , onInput <| AddFormMsg << ChangeRating
        ]
        (ratingOptions value_)


ratingOptions value_ =
    let
        ratingOption ( v, text_ ) =
            option [ value v, selected <| v == value_ ]
                [ text <| v ++ " - " ++ text_ ]
    in
        [ ( "1", "Trash" )
        , ( "2", "Meh" )
        , ( "3", "Acceptable" )
        , ( "4", "Good" )
        , ( "5", "Great" )
        ]
            |> List.map ratingOption
