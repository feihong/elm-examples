{- Example based on Richard Feldman's advice in this Reddit comment:
   https://www.reddit.com/r/elm/comments/5jd2xn/how_to_structure_elm_with_multiple_models/dbuu0m4/
-}


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Json.Decode as Decode
import Dom
import Task
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


type Msg
    = NoOp
    | AddFormMsg AddFormMsg
    | SubmitAddForm
    | DeleteBook Int



-- | SubmitBook


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        AddFormMsg msg ->
            { model | addForm = updateAddForm msg model.addForm } ! []

        SubmitAddForm ->
            let
                f =
                    model.addForm

                errors =
                    validateForm f

                ( newForm, newBook ) =
                    if List.isEmpty errors then
                        ( AddForm "" "" "" []
                        , [ Book f.title f.author (stringToRating f.rating) ]
                        )
                    else
                        ( { f | errors = errors }, [] )
            in
                { model
                    | addForm = newForm
                    , books = model.books ++ newBook
                }
                    ! [ Dom.focus "add-book-title-input" |> Task.attempt (\_ -> NoOp) ]

        DeleteBook index ->
            let
                newBooks =
                    model.books
                        |> List.indexedMap (,)
                        |> List.filterMap
                            (\( i, val ) ->
                                if index == i then
                                    Nothing
                                else
                                    Just val
                            )
            in
                { model | books = newBooks } ! []


updateAddForm : AddFormMsg -> AddForm -> AddForm
updateAddForm msg form =
    case msg of
        ChangeTitle str ->
            { form | title = str }

        ChangeAuthor str ->
            { form | author = str }

        ChangeRating str ->
            { form | rating = str }


validateForm : AddForm -> List ( String, String )
validateForm =
    Validate.all
        [ .title >> ifBlank ( "title", "Please enter a title" )
        , .author >> ifBlank ( "author", "Please enter an author" )
        , .rating >> ifBlank ( "rating", "Please select a rating" )
        ]


stringToRating str =
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
        , h1 [] [ text "Reading List" ]
        , table [ class "table table-striped" ]
            [ tableHead
            , tableBody model.books
            ]
        , addFormView model.addForm
        ]


tableHead =
    let
        th_ name =
            th [] [ text name ]
    in
        thead []
            [ tr []
                ([ "Title", "Author", "Rating", "Actions" ] |> List.map th_)
            ]


tableBody books =
    let
        td_ str =
            td [] [ text str ]

        star =
            span [ class "glyphicon glyphicon-star" ] []

        tr_ index book =
            tr []
                [ td_ book.title
                , td_ book.author
                , td [] (List.repeat book.rating (icon "star"))
                , td []
                    [ a [] [ icon "edit" ]
                    , text " "
                    , a [ onClick <| DeleteBook index ] [ icon "trash" ]
                    ]
                ]
    in
        tbody [] (books |> List.indexedMap tr_)


icon slug =
    span [ class <| "glyphicon glyphicon-" ++ slug ] []


addFormView { title, author, rating, errors } =
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
                        [ id "add-book-title-input"
                        , autofocus True
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
                        , onClick SubmitAddForm
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
