module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


last list =
    case list of
        [] ->
            Nothing

        hd :: [] ->
            Just hd

        hd :: tail ->
            last tail


tests : Test
tests =
    describe "hello"
        [ test "last [] returns Nothing" <|
            \() ->
                last []
                    |> Expect.equal Nothing
        , test "last [111] returns Just 111" <|
            \() ->
                last [ 111 ]
                    |> Expect.equal (Just 111)
        , test "last (List.range 1 1001) returns Just 1001" <|
            \() ->
                last (List.range 1 1001)
                    |> Expect.equal (Just 1001)
        ]


main : Runner.TestProgram
main =
    Runner.run tests
