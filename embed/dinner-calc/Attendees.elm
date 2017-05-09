module Attendees exposing (update, view)

import Set exposing (Set)
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
        OpenAttendeesDialog ->
            let
                newModel =
                    model
                        |> updateForm
                            { attendeesForm
                                | attendeesStr = ""
                                , attendeesErr = ""
                                , showDialog = not attendeesForm.showDialog
                            }
            in
                newModel
                    ! [ Dom.focus textareaId |> Task.attempt (always NoOp) ]

        CloseAttendeesDialog ->
            model
                |> updateForm { attendeesForm | showDialog = False }
                |> noCmd

        RemoveAttendee name ->
            let
                newAttendees =
                    attendees |> List.filter (\n -> n /= name)
            in
                { model | attendees = newAttendees }
                    |> noCmd

        ChangeAttendees str ->
            model
                |> updateForm { attendeesForm | attendeesStr = str }
                |> noCmd

        AddAttendees ->
            addAttendees model |> noCmd


addAttendees : Model -> Model
addAttendees ({ attendeesForm, attendees } as model) =
    let
        names =
            stringToNames attendeesForm.attendeesStr

        duplicates =
            duplicateNames attendees names
    in
        if Set.isEmpty duplicates then
            { model | attendees = List.sort (names ++ attendees) }
                |> updateForm { attendeesForm | showDialog = False }
        else
            model
                |> updateForm { attendeesForm | attendeesErr = "Duplicates detected" }


updateForm form model =
    { model | attendeesForm = form }


view ({ attendeesForm } as model) =
    div []
        [ h1 [] [ text "Attendees" ]
        , div [ class "attendees" ]
            (button
                [ class "btn btn-default"
                , onClick <| AttendeesMsg OpenAttendeesDialog
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
    { closeMessage = Just <| AttendeesMsg CloseAttendeesDialog
    , containerClass = Nothing
    , header = Just (h4 [ class "modal-title" ] [ text "Add attendees" ])
    , body = Just <| dialogBody attendeesForm
    , footer = Just <| dialogFooter attendeesForm
    }


dialogBody form =
    div
        [ class "form-group"
        , classList
            [ ( "has-error", stringIsNotEmpty form.attendeesErr )
            ]
        ]
        [ textarea
            [ id textareaId
            , rows 4
            , class "form-control"
            , placeholder "Names of attendees, separated by newlines"
            , value form.attendeesStr
            , onInput <| AttendeesMsg << ChangeAttendees
            ]
            []
        , div [ class "help-block" ] [ text form.attendeesErr ]
        ]


dialogFooter form =
    div []
        [ button
            [ class "btn btn-default"
            , onClick <| AttendeesMsg CloseAttendeesDialog
            ]
            [ text "Cancel" ]
        , button
            [ class "btn btn-primary"
            , disabled <| (String.isEmpty << String.trim) form.attendeesStr
            , onClick <| AttendeesMsg AddAttendees
            ]
            [ text "Add" ]
        ]


stringToNames : String -> List String
stringToNames str =
    String.split "\n" str
        |> List.map String.trim
        |> List.filter stringIsNotEmpty


duplicateNames : List String -> List String -> Set String
duplicateNames orig new =
    Set.intersect (Set.fromList orig) (Set.fromList new)
