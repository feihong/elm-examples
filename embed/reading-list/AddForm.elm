module AddForm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Model exposing (..)
import Msg exposing (..)
import ViewUtil exposing (..)


update : AddFormMsg -> Form -> Form
update msg form =
    case msg of
        ChangeTitle str ->
            { form | title = str }

        ChangeAuthor str ->
            { form | author = str }

        ChangeRating str ->
            { form | rating = str }


view : Form -> Html Msg
view { title, author, rating, errors } =
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
