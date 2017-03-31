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


fizzBuzz100 : () -> List String
fizzBuzz100 () =
    List.range 1 100
        |> List.map fizzBuzz


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
        , test "Does fizzBuzz100 return 100 numbers?" <|
            \() ->
                fizzBuzz100 ()
                    |> List.length
                    |> Expect.equal 100
        , test "Are the first 15 elements correct?" <|
            \() ->
                let
                    strings =
                        "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz"
                            |> String.split ","
                in
                    fizzBuzz100 ()
                        |> List.take 15
                        |> Expect.equal strings
        , test "Are the last 15 elements correct?" <|
            \() ->
                let
                    strings =
                        "86,Fizz,88,89,FizzBuzz,91,92,Fizz,94,Buzz,Fizz,97,98,Fizz,Buzz"
                            |> String.split ","
                in
                    fizzBuzz100 ()
                        |> List.drop 85
                        |> Expect.equal strings
        ]


main : Runner.TestProgram
main =
    Runner.run tests
