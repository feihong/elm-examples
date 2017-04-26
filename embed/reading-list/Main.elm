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
import Model exposing (..)
import Msg exposing (..)
import AddForm
import EditForm
import ListUtil
import ViewUtil exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


sampleBooks : List Book
sampleBooks =
    [ Book "Boxers" "Gene Luen Yang, Lark Pien" 4
    , Book "Saints" "Gene Luen Yang, Lark Pien" 3
    , Book "Aama" "Frederik Peeters" 4
    , Book "The Initiates: A Comic Artist and a Wine Artisan Exchange Jobs"
        "Étienne Davodeau"
        5
    , Book "Blacksad" "Juan Diaz Canales, Juanjo Guarnido" 4
    ]


init : ( Model, Cmd Msg )
init =
    { books = sampleBooks
    , addForm = defaultForm
    , showDialog = False
    , editForm = defaultForm
    , selectedIndex = 0
    }
        ! []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        AddFormMsg msg ->
            { model | addForm = AddForm.update msg model.addForm } ! []

        EditFormMsg msg ->
            { model | editForm = EditForm.update msg model.editForm } ! []

        SubmitAddForm ->
            submitAddForm model

        SubmitEditForm ->
            let
                form =
                    model.editForm

                newBooks =
                    if List.isEmpty form.errors then
                        model.books
                            |> ListUtil.replaceAt model.selectedIndex (formToBook form)
                    else
                        model.books
            in
                { model | books = newBooks, showDialog = False } ! []

        DeleteBook ->
            let
                newBooks =
                    model.books |> ListUtil.deleteAt model.selectedIndex
            in
                { model | books = newBooks, showDialog = False } ! []

        SelectBook index ->
            let
                newForm =
                    case ListUtil.elementAt index model.books of
                        Just book ->
                            bookToForm book

                        Nothing ->
                            defaultForm
            in
                { model
                    | editForm = newForm
                    , selectedIndex = index
                    , showDialog = True
                }
                    ! []

        CloseDialog ->
            { model | showDialog = False } ! []


submitAddForm : Model -> ( Model, Cmd Msg )
submitAddForm model =
    let
        form =
            model.addForm

        errors =
            validateForm form

        ( newForm, newBooks, cmds ) =
            if List.isEmpty errors then
                ( defaultForm
                , model.books ++ [ formToBook form ]
                , [ Dom.focus "add-book-title-input" |> Task.attempt (\_ -> NoOp) ]
                )
            else
                ( { form | errors = errors }, model.books, [] )
    in
        { model
            | addForm = newForm
            , books = newBooks
        }
            ! cmds


formToBook : Form -> Book
formToBook form =
    let
        stringToRating str =
            case Decode.decodeString Decode.int str of
                Ok value ->
                    value

                Err _ ->
                    0
    in
        Book form.title form.author (stringToRating form.rating)


bookToForm : Book -> Form
bookToForm { title, author, rating } =
    { title = title
    , author = author
    , rating = (toString rating)
    , errors = []
    , dirty = False
    }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ table [ class "table table-striped" ]
            [ tableHead
            , tableBody model.books
            ]
        , AddForm.view model.addForm
        , EditForm.view model.editForm model.showDialog
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

        tr_ index book =
            tr [ onClick <| SelectBook index ]
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
