module TestHelpers exposing (..)

import Test exposing (..)
import Expect
import Helpers exposing (..)
import Models exposing (..)


groupItems : List Item
groupItems =
    [ { payer = Group, name = "Chef Ping Platter", amount = 1250 }
    , { payer = Group, name = "Green Bean Casserole", amount = 550 }
    , { payer = Group, name = "Deep Dish Pizza", amount = 1600 }
    ]


mixedItems : List Item
mixedItems =
    groupItems
        ++ [ { payer = Attendee "Evan", name = "Maotai", amount = 930 }
           , { payer = Attendee "Murphy", name = "Mojito", amount = 500 }
           , { payer = Attendee "Murphy", name = "Margarita", amount = 605 }
           ]


simpleModel =
    { taxPercent = 9.75
    , tipPercent = 20.0
    , groupSize = 7
    , items = groupItems
    }


model =
    { taxPercent = 9.75
    , tipPercent = 20.0
    , groupSize = 7
    , items = mixedItems
    }


tests : Test
tests =
    describe "Helper tests"
        [ describe "centsToString"
            [ test "0" <|
                \() ->
                    centsToString 0
                        |> Expect.equal "0.00"
            , test "300" <|
                \() ->
                    centsToString 300
                        |> Expect.equal "3.00"
            , test "503" <|
                \() ->
                    centsToString 503
                        |> Expect.equal "5.03"
            , test "1136" <|
                \() ->
                    centsToString 1136
                        |> Expect.equal "11.36"
            ]
        , describe "stringToCents"
            [ test "45.23" <|
                \() ->
                    stringToCents "45.23"
                        |> Expect.equal (Ok 4523)
            , test "102" <|
                \() ->
                    stringToCents "102"
                        |> Expect.equal (Ok 10200)
            , test "34.12a" <|
                \() ->
                    stringToCents "34.12a"
                        |> Expect.equal (Err "Not a valid value for currency")
            ]
        , describe "calculate*"
            [ test "calculateBasics" <|
                \() ->
                    calculateBasics model
                        |> Expect.equal ( 5435, 1087, 530, 7052 )
            , test "calculate, simple" <|
                \() ->
                    calculate simpleModel
                        |> Expect.equal
                            { subtotal = 3400
                            , tax = 332
                            , tip = 680
                            , total = 4412
                            , breakdown = EveryonePays 631
                            }
            , test "calculate, complex" <|
                \() ->
                    calculate model
                        |> Expect.equal
                            { subtotal = 5435
                            , tax = 1087
                            , tip = 530
                            , total = 7052
                            , breakdown =
                                ComplexBreakdown
                                    [ ( "Evan", 1837 ), ( "Murphy", 2064 ) ]
                                    631
                            }
            ]
        ]
