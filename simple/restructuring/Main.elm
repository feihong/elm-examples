{- Example based on Richard Feldman's advice in this Reddit comment:
   https://www.reddit.com/r/elm/comments/5jd2xn/how_to_structure_elm_with_multiple_models/dbuu0m4/
-}


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Json.Decode as Decode
import Util


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Book =
    { title : String
    , author : String
    , rating : Int
    }


type alias Model =
    { books : List Book
    }


init : ( Model, Cmd Msg )
init =
    let
        books =
            [ Book "Boxers" "Gene Luen Yang, Lark Pien" 4
            , Book "Saints" "Gene Luen Yang, Lark Pien" 3
            , Book "Aama" "Frederik Peeters" 4
            , Book "The Initiates: A Comic Artist and a Wine Artisan Exchange Jobs"
                "Étienne Davodeau"
                5
            ]
    in
        { books = books
        }
            ! []



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ Util.bootstrap
        , h1 [] [ text "Books" ]
        , table [ class "table table-striped" ]
            [ tableHead
            , tableBody model.books
            ]
        ]


tableHead =
    let
        th_ name =
            th [] [ text name ]
    in
        thead []
            [ tr []
                ([ "Title", "Author", "Rating" ] |> List.map th_)
            ]


tableBody books =
    let
        td_ str =
            td [] [ text str ]

        star =
            span [ class "glyphicon glyphicon-star" ] []

        tr_ book =
            tr []
                [ td_ book.title
                , td_ book.author
                , td [] (List.repeat book.rating star)
                ]
    in
        tbody [] (books |> List.map tr_)
