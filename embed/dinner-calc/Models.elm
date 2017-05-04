module Models exposing (..)

-- sampleItems =
--     [ { payer = Group, name = "Chef Ping Platter", amount = 1235 }
--     , { payer = Group, name = "Green Bean Casserole", amount = 550 }
--     , { payer = Group, name = "Deep Dish Pizza", amount = 1600 }
--     , { payer = Attendee "Norman", name = "Maotai", amount = 1500 }
--     , { payer = Attendee "Cameron", name = "Mojito", amount = 500 }
--     , { payer = Attendee "Cameron", name = "Margarita", amount = 450 }
--     ]
-- sampleItemForms =
--     sampleItems
--         |> List.map
--             (\item ->
--                 ItemsForm.ItemForm
--                     (case item.payer of
--                         Group ->
--                             "Group"
--                         Attendee name ->
--                             name
--                     )
--                     item.name
--                     (toString item.amount)
--                     []
--             )
-- samplePayers =
--     sampleItems
--         |> List.filter (\item -> item.payer /= Group)
--         |> List.map
--             (\item ->
--                 case item.payer of
--                     Group ->
--                         ""
--                     Attendee name ->
--                         name
--             )
--         |> Set.fromList
--         |> Set.toList


defaultTaxPercent =
    9.75


defaultTipPercent =
    20.0



-- initialModel =
--     { taxPercent = defaultTaxPercent
--     , tipPercent = defaultTipPercent
--     , taxPercentErr = ""
--     , tipPercentErr = ""
--     , groupSizeErr = ""
--     , individualPayers = samplePayers
--     , newPayer = ""
--     , newPayerErr = ""
--     , showDialog = False
--     , items =
--         sampleItems
--         -- , formState = ItemsForm.initialState
--     , formState = { newItem = ItemsForm.ItemForm "Group" "" "" [], items = sampleItemForms }
--     }


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



-- type Msg
--     = NoOp
--       -- Top form
--     | ChangeTaxPercent String
--     | ChangeTipPercent String
--     | ChangeGroupSize String
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
