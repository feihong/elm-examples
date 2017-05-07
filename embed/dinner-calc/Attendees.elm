module Attendees exposing (update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Dom
import Task
import Dialog
import Models exposing (..)
import ViewUtil exposing (..)
import Util exposing (..)


textareaId =
    "add-attendees-textarea"


update : AttendeesMsg -> Model -> ( Model, Cmd Msg )
update msg ({ attendeesForm, attendees } as model) =
    case msg of
        ToggleAttendeesDialog ->
            let
                newModel =
                    model
                        |> updateForm { attendeesForm | showDialog = not attendeesForm.showDialog }
            in
                newModel
                    ! [ Dom.focus textareaId |> Task.attempt (always NoOp) ]

        RemoveAttendee name ->
            let
                newAttendees =
                    attendees |> List.filter (\n -> n /= name)
            in
                { model | attendees = newAttendees }
                    |> noCmd


updateForm form model =
    { model | attendeesForm = form }


view ({ attendeesForm } as model) =
    div []
        [ h1 [] [ text "Attendees" ]
        , div [ class "attendees" ]
            (button
                [ class "btn btn-default"
                , onClick <| AttendeesMsg ToggleAttendeesDialog
                ]
                [ icon "plus", text "Add" ]
                :: (model.attendees |> List.map attendeePill)
            )
        , Dialog.view
            (if attendeesForm.showDialog then
                Just <| dialogConfig model
             else
                Nothing
            )
        ]


attendeePill name =
    div
        [ class "attendee"
        , onClick <| AttendeesMsg (RemoveAttendee name)
        ]
        [ icon "remove", text name ]


dialogConfig : Model -> Dialog.Config Msg
dialogConfig { attendeesForm } =
    { closeMessage = Just <| AttendeesMsg ToggleAttendeesDialog
    , containerClass = Nothing
    , header = Just (h4 [ class "modal-title" ] [ text "Add attendees" ])
    , body = Just <| dialogBody attendeesForm
    , footer = Just dialogFooter
    }


dialogBody form =
    div
        [ class "form-group"
        , classList
            [ ( "has-error", Util.stringIsNotEmpty form.attendeesStr )
            ]
        ]
        [ textarea
            [ id textareaId
            , class "form-control"
            , placeholder "Names of attendees, separated by commas"
            , value form.attendeesStr

            -- , onInput UpdateNewPayer
            -- , ViewUtil.onKeyEnter AddPayer
            ]
            []
        , div [ class "help-block" ] [ text form.attendeesErr ]
        ]


dialogFooter =
    div []
        [ button
            [ class "btn btn-default"
            , onClick <| AttendeesMsg ToggleAttendeesDialog
            ]
            [ text "Cancel" ]
        , button
            [ class "btn btn-primary"
            , onClick <| NoOp
            ]
            [ text "Add" ]
        ]
