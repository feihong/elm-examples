module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


isPalindrome : List a -> Bool
isPalindrome list =
    (List.reverse list) == list



-- isPalindrome : List a -> Bool
-- isPalindrome list =
--     let
--         halfIndex =
--             List.length list // 2
--         firstHalf =
--             List.take halfIndex list
--         secondHalf =
--             List.take halfIndex (List.reverse list)
--     in
--         firstHalf == secondHalf


tests : Test
tests =
    describe "isPalindrome"
        [ test "Empty list" <|
            \() ->
                isPalindrome []
                    |> Expect.equal True
        , test "Single element" <|
            \() ->
                isPalindrome [ 'a' ]
                    |> Expect.equal True
        , test "Three elements" <|
            \() ->
                isPalindrome [ 'a', 'b', 'c' ]
                    |> Expect.equal False
        , test "Three elements" <|
            \() ->
                isPalindrome [ 'a', 'b', 'a' ]
                    |> Expect.equal True
        , test "Many elements" <|
            \() ->
                (List.range 1 500)
                    ++ (List.reverse (List.range 1 500))
                    |> isPalindrome
                    |> Expect.equal True
        ]


main : Runner.TestProgram
main =
    Runner.run tests
