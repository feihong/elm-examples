{- Example based on Richard Feldman's advice in this Reddit comment:
   https://www.reddit.com/r/elm/comments/5jd2xn/how_to_structure_elm_with_multiple_models/dbuu0m4/
-}


module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Json.Decode as Decode
import Validate exposing (ifBlank)
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


type alias AddForm =
    { title : String
    , author : String
    , rating : String
    , errors : List ( String, String )
    }


type alias Model =
    { books : List Book
    , addForm : AddForm
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
            , Book "Blacksad" "Juan Diaz Canales, Juanjo Guarnido" 4
            ]
    in
        { books = books
        , addForm = { title = "", author = "", rating = "", errors = [] }
        }
            ! []



-- UPDATE


type AddFormMsg
    = ChangeTitle String
    | ChangeAuthor String
    | ChangeRating String
    | Submit


type Msg
    = NoOp
    | AddFormMsg AddFormMsg
    | AddBook String String Int



-- | SubmitBook


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        AddFormMsg msg ->
            let
                ( newForm, maybeMsg ) =
                    updateAddForm msg model.addForm

                newModel =
                    { model | addForm = newForm }
            in
                case maybeMsg of
                    Nothing ->
                        newModel ! []

                    Just newMsg ->
                        update newMsg newModel

        AddBook title author rating ->
            let
                newBooks =
                    model.books ++ [ Book title author rating ]
            in
                { model | books = newBooks } ! []


updateAddForm : AddFormMsg -> AddForm -> ( AddForm, Maybe Msg )
updateAddForm msg form =
    case msg of
        ChangeTitle str ->
            ( { form | title = str }, Nothing )

        ChangeAuthor str ->
            ( { form | author = str }, Nothing )

        ChangeRating str ->
            ( { form | rating = str }, Nothing )

        Submit ->
            let
                errors =
                    validateForm form |> Debug.log "errors"
            in
                if List.isEmpty errors then
                    ( AddForm "" "" "" []
                    , Just <| AddBook form.title form.author (stringToInt form.rating)
                    )
                else
                    ( { form | errors = errors }, Nothing )


validateForm : AddForm -> List ( String, String )
validateForm =
    Validate.all
        [ .title >> ifBlank ( "title", "Please enter a title" )
        , .author >> ifBlank ( "author", "Please enter an author" )
        , .rating >> ifBlank ( "rating", "Please select a rating" )
        ]


stringToInt str =
    case Decode.decodeString Decode.int str of
        Ok value ->
            value

        Err _ ->
            0



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
        , bookForm model.addForm
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


bookForm { title, author, rating, errors } =
    let
        hasError name =
            errors |> List.any (\( name_, _ ) -> name_ == name)
    in
        div [ class "form-horizontal" ]
            [ div [ class "form-group" ]
                [ div
                    [ classList
                        [ ( "col-sm-4", True )
                        , ( "has-error", hasError "title" )
                        ]
                    ]
                    [ input
                        [ autofocus True
                        , class "form-control"
                        , placeholder "Title"
                        , value title
                        , onInput (AddFormMsg << ChangeTitle)
                        ]
                        []
                    ]
                , div
                    [ classList
                        [ ( "col-sm-4", True )
                        , ( "has-error", hasError "author" )
                        ]
                    ]
                    [ input
                        [ class "form-control"
                        , placeholder "Author"
                        , value author
                        , onInput (AddFormMsg << ChangeAuthor)
                        ]
                        []
                    ]
                , div
                    [ classList
                        [ ( "col-sm-3", True )
                        , ( "has-error", hasError "rating" )
                        ]
                    ]
                    [ ratingsSelect rating
                    ]
                , div [ class "col-sm-1" ]
                    [ button
                        [ class "btn btn-default"
                        , onClick (AddFormMsg Submit)
                        ]
                        [ text "Add" ]
                    ]
                ]
            , div [ class "help-block" ]
                [ text <|
                    case List.head errors of
                        Just ( _, value ) ->
                            value

                        Nothing ->
                            ""
                ]
            ]


ratingsSelect value_ =
    let
        blankOption =
            option [ value "" ] [ text "Rating" ]

        dividerOption =
            option [ value "", disabled True ] [ text "-----" ]

        options =
            List.range 1 5
                |> List.map toString
                |> List.map
                    (\v ->
                        option
                            [ value v
                            , selected <| v == value_
                            ]
                            [ text v ]
                    )
    in
        select
            [ class "form-control"
            , value value_
            , onInput (AddFormMsg << ChangeRating)
            ]
            (blankOption :: dividerOption :: options)
