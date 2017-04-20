module Models exposing (..)

import Dom
import ItemsForm


sampleItems =
    [ { payer = Group, name = "Chef Ping Platter", amount = 1235 }
    , { payer = Group, name = "Green Bean Casserole", amount = 550 }
    , { payer = Group, name = "Deep Dish Pizza", amount = 1600 }
    , { payer = Attendee "Norman", name = "Maotai", amount = 1500 }
    , { payer = Attendee "Cameron", name = "Mojito", amount = 500 }
    , { payer = Attendee "Cameron", name = "Margarita", amount = 450 }
    ]


samplePayers =
    [ "Bob", "Hobo" ]


type Payer
    = Group
    | Attendee String


{-| Note that amount is in cents, not dollars.
-}
type alias Item =
    { payer : Payer
    , name : String
    , amount : Int
    }


defaultTaxPercent =
    9.75


defaultTipPercent =
    20.0


defaultGroupSize =
    6


initialModel =
    { taxPercent = defaultTaxPercent
    , tipPercent = defaultTipPercent
    , groupSize = defaultGroupSize
    , taxPercentErr = ""
    , tipPercentErr = ""
    , groupSizeErr = ""
    , individualPayers = samplePayers
    , newPayer = ""
    , newPayerErr = ""
    , showDialog = False
    , items = sampleItems
    , formState = ItemsForm.initialState
    }


type alias Model =
    { taxPercent : Float
    , tipPercent : Float
    , groupSize : Int
    , taxPercentErr : String
    , tipPercentErr : String
    , groupSizeErr : String
    , individualPayers : List String
    , newPayer : String
    , newPayerErr : String
    , showDialog : Bool
    , items : List Item
    , formState : ItemsForm.State
    }


type Breakdown
    = EveryonePays Int
    | ComplexBreakdown (List ( String, Int )) Int


type alias Calculation =
    { subtotal : Int
    , tax : Int
    , tip : Int
    , total : Int
    , breakdown : Breakdown
    }


type Msg
    = NoOp
      -- Top form
    | ChangeTaxPercent String
    | ChangeTipPercent String
    | ChangeGroupSize String
      -- Payer
    | RemovePayer String
    | AddPayer
    | UpdateNewPayer String
    | ToggleDialog
    | FocusOn Dom.Id
    | FocusResult (Result Dom.Error ())
      -- Items
    | SetFormState ItemsForm.Msg
    | AddItem String String Int
    | UpdateItem Int String String Int
    | RemoveItem Int
