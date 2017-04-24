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
import Dialog


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
    , showDialog : Bool
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
        , addForm = { title = "", author = "", rating = "3", errors = [] }
        , showDialog = False
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
    | ToggleDialog



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
                        ( AddForm "" "" "3" []
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

        ToggleDialog ->
            let
                cmds =
                    if not model.showDialog then
                        [ Dom.focus "edit-book-title-input" |> Task.attempt (\_ -> NoOp) ]
                    else
                        []
            in
                { model | showDialog = not model.showDialog } ! cmds


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
    div []
        [ table [ class "table table-striped" ]
            [ tableHead
            , tableBody model.books
            ]
        , addFormView model.addForm
        , Dialog.view
            (if model.showDialog then
                Just <| dialogConfig model.addForm
             else
                Nothing
            )
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

        tr_ index book =
            tr [ onClick ToggleDialog ]
                [ td_ book.title
                , td_ book.author
                , td [] (stars book.rating)
                ]
    in
        tbody [] (books |> List.indexedMap tr_)


icon slug =
    span [ class <| "glyphicon glyphicon-" ++ slug ] []


stars rating =
    List.append
        (List.repeat rating (icon "star"))
        (List.repeat (5 - rating) (icon "star-empty"))


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
    select
        [ class "form-control"
        , value value_
        , onInput (AddFormMsg << ChangeRating)
        ]
        (ratingOptions value_)


ratingOptions value_ =
    [ ( "1", "Trash" ), ( "2", "Meh" ), ( "3", "Acceptable" ), ( "4", "Good" ), ( "5", "Great" ) ]
        |> List.map
            (\( v, str ) ->
                option [ value v, selected <| v == value_ ]
                    [ text <| v ++ " - " ++ str ]
            )


dialogConfig : AddForm -> Dialog.Config Msg
dialogConfig form =
    { closeMessage = Just ToggleDialog
    , containerClass = Nothing
    , header = Just (h4 [ class "modal-title" ] [ text "Edit book" ])
    , body = Just <| dialogBody form
    , footer = Just dialogFooter
    }


dialogBody form =
    div [ class "form-horizontal" ]
        [ dialogInput "Title" form.title "error"
        , dialogInput "Author" form.author "error"
        , dialogSelect form.rating
        ]


dialogInput labelName value_ errMesg =
    let
        inputId =
            if labelName == "Title" then
                [ id "edit-book-title-input" ]
            else
                []
    in
        div
            [ classList
                [ ( "form-group", True )
                , ( "has-error", not <| String.isEmpty errMesg )
                ]
            ]
            [ label [ class "col-sm-2 control-label" ]
                [ text labelName ]
            , div [ class "col-sm-10" ]
                [ input
                    (inputId
                        ++ [ class "form-control"
                           , value value_
                           ]
                    )
                    []
                ]
            , div [ class "col-sm-offset-2 col-sm-10 help-block" ] [ text errMesg ]
            ]


dialogSelect value_ =
    div [ class "form-group" ]
        [ label [ class "col-sm-2 control-label" ] [ text "Rating" ]
        , div [ class "col-sm-10" ]
            [ select
                [ class "form-control"
                , value value_
                ]
                (ratingOptions value_)
            ]
        ]


dialogFooter =
    div []
        [ button [ class "btn btn-danger pull-left", onClick ToggleDialog ]
            [ text "Delete" ]
        , button [ class "btn btn-default", onClick ToggleDialog ]
            [ text "Cancel" ]
        , button [ class "btn btn-primary", onClick ToggleDialog ]
            [ text "Save" ]
        ]
