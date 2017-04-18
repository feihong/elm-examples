module RegexKoans exposing (..)

import Regex
import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


currencyRegex : Regex.Regex
currencyRegex =
    Regex.regex "^[0-9]{1,3}(?:,?[0-9]{3})*(?:\\.[0-9]{2})?$"


moneyRegex : Regex.Regex
moneyRegex =
    Regex.regex "\\$[0-9]{1,3}(?:,?[0-9]{3})*(?:\\.[0-9]{2})?"


tests : Test
tests =
    describe "Regex koans"
        [ test "12" <|
            \() ->
                [ "12", "12.0", "12.00", "12.000" ]
                    |> List.map (Regex.contains currencyRegex)
                    |> Expect.equal [ True, False, True, False ]
        , test "15126.4" <|
            \() ->
                [ "15126.4", "15126.40", "15,126.40" ]
                    |> List.map (Regex.contains currencyRegex)
                    |> Expect.equal [ False, True, True ]
        , test "find all" <|
            \() ->
                "The total bill was $12,567.34. You owe us $4,981.92."
                    |> Regex.find Regex.All moneyRegex
                    |> List.map .match
                    |> Expect.equal [ "$12,567.34", "$4,981.92" ]
        , test "find at most 2" <|
            \() ->
                "The total bill was $12,567.34. You owe us $4,981.92. "
                    ++ "The minimum payment is $230.44. Please remit to Turtle Dental"
                    |> Regex.find (Regex.AtMost 2) moneyRegex
                    |> List.map .match
                    |> Expect.equal [ "$12,567.34", "$4,981.92" ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
