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


type alias Form =
    { title : String
    , author : String
    , rating : String
    , errors : List ( String, String )
    , dirty : Bool
    }


type alias Model =
    { books : List Book
    , addForm : Form
    , showDialog : Bool
    , editForm : Form
    , selectedIndex : Int
    }


defaultForm : Form
defaultForm =
    { title = "", author = "", rating = "3", errors = [], dirty = False }


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


type AddFormMsg
    = ChangeTitle String
    | ChangeAuthor String
    | ChangeRating String


{-| Elm won't let us use the same names for these message constructors, even
    though they have the same meaning as the ones under AddFormMsg. In a larger
    program, we would move them into a separate module.
-}
type EditFormMsg
    = ChangeEditTitle String
    | ChangeEditAuthor String
    | ChangeEditRating String


type Msg
    = NoOp
    | AddFormMsg AddFormMsg
    | EditFormMsg EditFormMsg
    | SubmitAddForm
    | SubmitEditForm
    | SelectBook Int
    | DeleteBook
    | CloseDialog



-- | SubmitBook


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        AddFormMsg msg ->
            { model | addForm = updateAddForm msg model.addForm } ! []

        EditFormMsg msg ->
            { model | editForm = updateEditForm msg model.editForm } ! []

        SubmitAddForm ->
            submitAddForm model

        SubmitEditForm ->
            let
                form =
                    model.editForm

                newBooks =
                    if List.isEmpty form.errors then
                        model.books
                            |> replaceAt model.selectedIndex (formToBook form)
                    else
                        model.books
            in
                { model | books = newBooks, showDialog = False } ! []

        DeleteBook ->
            let
                newBooks =
                    model.books |> deleteAt model.selectedIndex
            in
                { model | books = newBooks, showDialog = False } ! []

        SelectBook index ->
            let
                newForm =
                    case elementAt index model.books of
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


updateAddForm : AddFormMsg -> Form -> Form
updateAddForm msg form =
    case msg of
        ChangeTitle str ->
            { form | title = str }

        ChangeAuthor str ->
            { form | author = str }

        ChangeRating str ->
            { form | rating = str }


updateEditForm : EditFormMsg -> Form -> Form
updateEditForm msg form =
    case msg of
        ChangeEditTitle str ->
            let
                newForm =
                    { form | title = str }

                errors =
                    validateForm newForm
            in
                { newForm | errors = errors, dirty = True }

        ChangeEditAuthor str ->
            let
                newForm =
                    { form | author = str }

                errors =
                    validateForm newForm
            in
                { newForm | errors = errors, dirty = True }

        ChangeEditRating str ->
            { form | rating = str, dirty = True }


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


validateForm : Form -> List ( String, String )
validateForm =
    Validate.all
        [ .title >> ifBlank ( "title", "Please enter a title" )
        , .author >> ifBlank ( "author", "Please enter an author" )
        ]


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
        , addFormView model.addForm
        , Dialog.view
            (if model.showDialog then
                Just <| dialogConfig model.editForm
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


addFormView : Form -> Html Msg
addFormView { title, author, rating, errors } =
    let
        hasError name =
            errors |> List.any (\( name_, _ ) -> name_ == name)

        errorText =
            if List.isEmpty errors then
                ""
            else
                (String.join ". " (List.map Tuple.second errors)) ++ "."
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
                        , onInput <| AddFormMsg << ChangeTitle
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
                        , onInput <| AddFormMsg << ChangeAuthor
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
            , div [ class "help-block" ] [ text errorText ]
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


dialogConfig : Form -> Dialog.Config Msg
dialogConfig form =
    { closeMessage = Just CloseDialog
    , containerClass = Nothing
    , header = Just <| h4 [ class "modal-title" ] [ text "Edit book" ]
    , body = Just <| dialogBody form
    , footer = Just <| dialogFooter form
    }


dialogBody { title, author, rating, errors } =
    let
        hasError name =
            errors |> List.any (\( key, val ) -> name == key)

        getErrMesg name =
            errors
                |> elementWith (\( key, val ) -> name == key)
                |> Maybe.map Tuple.second
                |> Maybe.withDefault ""
    in
        div [ class "form-horizontal" ]
            [ div
                [ classList
                    [ ( "form-group", True )
                    , ( "has-error", hasError "title" )
                    ]
                ]
                [ label [ class "col-sm-2 control-label" ]
                    [ text "Title" ]
                , div [ class "col-sm-10" ]
                    [ input
                        [ class "form-control"
                        , value title
                        , onInput <| EditFormMsg << ChangeEditTitle
                        ]
                        []
                    ]
                , div [ class "col-sm-offset-2 col-sm-10 help-block" ]
                    [ text <| getErrMesg "title" ]
                ]
            , div
                [ classList
                    [ ( "form-group", True )
                    , ( "has-error", hasError "author" )
                    ]
                ]
                [ label [ class "col-sm-2 control-label" ]
                    [ text "Author" ]
                , div [ class "col-sm-10" ]
                    [ input
                        [ class "form-control"
                        , value author
                        , onInput <| EditFormMsg << ChangeEditAuthor
                        ]
                        []
                    ]
                , div [ class "col-sm-offset-2 col-sm-10 help-block" ]
                    [ text <| getErrMesg "author" ]
                ]
            , dialogSelect rating
            ]


dialogSelect value_ =
    div [ class "form-group" ]
        [ label [ class "col-sm-2 control-label" ] [ text "Rating" ]
        , div [ class "col-sm-10" ]
            [ select
                [ class "form-control"
                , value value_
                , onInput <| EditFormMsg << ChangeEditRating
                ]
                (ratingOptions value_)
            ]
        ]


dialogFooter { errors, dirty } =
    let
        enabled =
            List.isEmpty errors && dirty
    in
        div []
            [ button
                [ class "btn btn-danger pull-left"
                , onClick <| DeleteBook
                ]
                [ text "Delete" ]
            , button [ class "btn btn-default", onClick CloseDialog ]
                [ text "Cancel" ]
            , button
                [ class "btn btn-primary"
                , onClick SubmitEditForm
                , disabled <| not enabled
                ]
                [ text "Save" ]
            ]


deleteAt : Int -> List a -> List a
deleteAt index list =
    list
        |> List.indexedMap (,)
        |> List.filterMap
            (\( i, val ) ->
                if index == i then
                    Nothing
                else
                    Just val
            )


elementAt : Int -> List a -> Maybe a
elementAt index list =
    list
        |> List.indexedMap (,)
        |> List.filterMap
            (\( i, v ) ->
                if i == index then
                    Just v
                else
                    Nothing
            )
        |> List.head


replaceAt : Int -> a -> List a -> List a
replaceAt index value list =
    list
        |> List.indexedMap (,)
        |> List.map
            (\( i, v ) ->
                if i == index then
                    value
                else
                    v
            )


elementWith : (a -> Bool) -> List a -> Maybe a
elementWith pred list =
    list |> List.filter pred |> List.head
