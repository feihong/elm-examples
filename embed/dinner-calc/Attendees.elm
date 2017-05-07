module Attendees exposing (update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Models exposing (..)
import ViewUtil exposing (..)


update msg ({ attendeesForm, attendees } as model) =
    case msg of
        ToggleAttendeesDialog ->
            model
                |> updateForm { attendeesForm | showDialog = not attendeesForm.showDialog }

        RemoveAttendee name ->
            let
                newAttendees =
                    attendees |> List.filter (\n -> n /= name)
            in
                { model | attendees = newAttendees }


updateForm form model =
    { model | attendeesForm = form }


view model =
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
        ]


attendeePill name =
    div
        [ class "attendee"
        , onClick <| AttendeesMsg (RemoveAttendee name)
        ]
        [ icon "remove", text name ]
