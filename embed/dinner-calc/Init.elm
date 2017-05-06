module Init exposing (init)

import Models exposing (..)


init : ( Model, Cmd Msg )
init =
    initialModel ! []


sampleItems =
    [ { attendee = "Norman", name = "Maotai", amount = 1500 }
    , { attendee = "Cameron", name = "Mojito", amount = 500 }
    , { attendee = "Cameron", name = "Margarita", amount = 450 }
    ]


sampleAttendees =
    [ "Norman", "Cameron", "Snoop Dawg", "Esther", "Magneto" ]


defaultTaxPercent =
    9.75


defaultTipPercent =
    20.0


defaultSubtotal =
    2000


initialModel : Model
initialModel =
    { taxPercent = defaultTaxPercent
    , tipPercent = defaultTipPercent
    , subtotal = defaultSubtotal
    , attendees = sampleAttendees
    , items = sampleItems
    , numbersForm = NumbersForm "" "" ""
    , attendeesForm = AttendeesForm "" "" False
    }
