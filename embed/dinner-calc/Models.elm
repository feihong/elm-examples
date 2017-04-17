module Models exposing (..)


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


type alias ItemForm =
    { payer : String, name : String, amount : String }


type alias Model =
    { taxPercent : Float
    , tipPercent : Float
    , groupSize : Int
    , taxPercentErr : String
    , tipPercentErr : String
    , groupSizeErr : String
    , individualPayers : List String
    , newPayer : String
    , showDialog : Bool
    , items : List Item
    , newItemForm : ItemForm
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
