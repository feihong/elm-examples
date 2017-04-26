module ViewUtil exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Validate exposing (ifBlank)
import Model exposing (..)
import Msg exposing (..)


validateForm : Form -> List ( String, String )
validateForm =
    Validate.all
        [ .title >> ifBlank ( "title", "Please enter a title" )
        , .author >> ifBlank ( "author", "Please enter an author" )
        ]


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
