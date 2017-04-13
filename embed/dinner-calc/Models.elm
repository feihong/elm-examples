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


type alias Model =
    { taxPercent : Float
    , tipPercent : Float
    , groupSize : Int
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
