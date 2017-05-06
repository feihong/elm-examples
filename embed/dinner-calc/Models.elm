module Models exposing (..)

{-| Money, in cents
-}


type alias Money =
    Int


{-| The name of an attendee
-}
type alias Attendee =
    String


{-| An individual item, not shared with the group
-}
type alias Item =
    { attendee : Attendee
    , name : String
    , amount : Money
    }


type alias Model =
    { taxPercent : Float
    , tipPercent : Float
    , subtotal : Money
    , attendees : List Attendee
    , items : List Item
    , numbersForm : NumbersForm
    , attendeesForm : AttendeesForm
    }


type alias NumbersForm =
    { taxPercentErr : String
    , tipPercentErr : String
    , subtotalErr : String
    }


type alias AttendeesForm =
    { attendeesStr : String
    , attendeesErr : String
    , showDialog : Bool
    }


{-| Complex breakdown contains list of (name, amount) tuples describing
attendees who ordered individual items and how much they need to pay. The
second argument to ComplexBreakdown is the amount that everyone else needs
to pay.
-}
type Breakdown
    = EveryonePays Money
    | ComplexBreakdown (List ( Attendee, Money )) Money


type alias Calculation =
    { tax : Int
    , tip : Int
    , total : Int
    , breakdown : Breakdown
    }


type NumbersFormMsg
    = ChangeTaxPercent String
    | ChangeTipPercent String
    | ChangeSubtotal String



--     | ChangeTipPercent String
--     | ChangeSubtotal String


type Msg
    = NoOp
    | NumbersFormMsg NumbersFormMsg



--       -- Top form
--     |
--       -- Payer
--     | RemovePayer String
--     | AddPayer
--     | UpdateNewPayer String
--     | ToggleDialog
--     | FocusOn Dom.Id
--     | FocusResult (Result Dom.Error ())
--       -- Items
--     | SetFormState ItemsForm.Msg
--     | AddItem String String Int
--     | UpdateItem Int String String Int
--     | RemoveItem Int
