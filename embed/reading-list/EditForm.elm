module EditForm exposing (view, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Dialog
import Model exposing (..)
import Msg exposing (..)
import ViewUtil exposing (..)
import ListUtil exposing (..)


update : EditFormMsg -> Form -> Form
update msg form =
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


view : Form -> Bool -> Html Msg
view form showDialog =
    Dialog.view
        (if showDialog then
            Just <| dialogConfig form
         else
            Nothing
        )


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
                |> ListUtil.elementWith (\( key, val ) -> name == key)
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
