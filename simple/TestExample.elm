module TestExample exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


fizzBuzz : Int -> String
fizzBuzz x =
    if x % 3 == 0 && x % 5 == 0 then
        "FizzBuzz"
    else if x % 3 == 0 then
        "Fizz"
    else if x % 5 == 0 then
        "Buzz"
    else
        toString x


tests : Test
tests =
    describe "FizzBuzz tests"
        [ test "Multiples of 3 return Fizz" <|
            \() ->
                let
                    nums =
                        [ 3, 18, 54, 72, 99 ]
                in
                    List.map fizzBuzz nums
                        |> Expect.equal (List.repeat 5 "Fizz")
        , test "Multiples of 5 return Buzz" <|
            \() ->
                let
                    nums =
                        [ 5, 25, 50, 80, 95 ]
                in
                    List.map fizzBuzz nums
                        |> Expect.equal (List.repeat 5 "Buzz")
        , test "Multiples of both 3 and 5 return FizzBuzz" <|
            \() ->
                let
                    nums =
                        [ 15, 45, 60, 75, 90 ]
                in
                    List.map fizzBuzz nums
                        |> Expect.equal (List.repeat 5 "FizzBuzz")
        , test "Other numbers return the number itself (as a string)" <|
            \() ->
                let
                    nums =
                        [ 1, 2, 4, 7, 11, 32, 43, 59, 89, 94 ]
                in
                    List.map fizzBuzz nums
                        |> Expect.equal (List.map toString nums)
        ]


main : Runner.TestProgram
main =
    Runner.run tests
