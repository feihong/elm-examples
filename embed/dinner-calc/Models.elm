module Models exposing (..)

import Dom


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


initialModel =
    { taxPercent = 9.75
    , tipPercent = 20.0
    , groupSize = 6
    , taxPercentErr = ""
    , tipPercentErr = ""
    , groupSizeErr = ""
    , individualPayers = samplePayers
    , newPayer = ""
    , newPayerErr = ""
    , showDialog = False
    , items = sampleItems
    }



-- type alias ItemForm =
--     { payer : String, name : String, amount : String }


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
    = Temp String
    | ChangeTaxPercent String
    | ChangeTipPercent String
    | ChangeGroupSize String
    | RemovePayer String
    | AddPayer
    | UpdateNewPayer String
    | ToggleDialog
    | ChangeNewItemPayer String
    | ChangeNewItemName String
    | ChangeNewItemAmount String
    | NewItem
    | FocusOn Dom.Id
    | FocusResult (Result Dom.Error ())
