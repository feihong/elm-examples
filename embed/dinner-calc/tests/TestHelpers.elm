module TestHelpers exposing (..)

import Test exposing (..)
import Expect
import Helpers exposing (..)
import Models exposing (..)


attendees : List Attendee
attendees =
    [ "Evan", "Murphy", "Tessa", "Jessica", "Luke", "Gutedama" ]


simpleModel : Model
simpleModel =
    { taxPercent = 9.75
    , tipPercent = 20.0
    , subtotal = 8823
    , attendees = attendees
    , items = []
    , numbersForm = NumbersForm "" "" ""
    , attendeesForm = AttendeesForm "" "" False
    }


items : List Item
items =
    [ { attendee = "Evan", name = "Maotai", amount = 930 }
    , { attendee = "Murphy", name = "Mojito", amount = 500 }
    , { attendee = "Murphy", name = "Margarita", amount = 605 }
    ]


model : Model
model =
    { simpleModel | items = items }


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
                        |> Expect.equal ( 1765, 860, 11448, 6 )
            , test "calculate, simple" <|
                \() ->
                    calculate simpleModel
                        |> Expect.equal
                            { tax = 860
                            , tip = 1765
                            , total = 11448
                            , breakdown = EveryonePays 1908
                            }
            , test "calculate, complex" <|
                \() ->
                    calculate model
                        |> Expect.equal
                            { tax = 860
                            , tip = 1765
                            , total = 11448
                            , breakdown =
                                ComplexBreakdown
                                    [ ( "Evan", 2675 ), ( "Murphy", 2902 ) ]
                                    1468
                            }
            ]
        ]
