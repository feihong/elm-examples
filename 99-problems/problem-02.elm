module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


penultimate : List a -> Maybe a
penultimate list =
    case list of
        [] ->
            Nothing

        [ _ ] ->
            Nothing

        [ x, _ ] ->
            Just x

        _ :: tail ->
            penultimate tail



-- penultimate : List a -> Maybe a
-- penultimate list =
--     case List.reverse list of
--         [] ->
--             Nothing
--         _ :: tail ->
--             List.head tail


tests : Test
tests =
    describe "penultimate"
        [ test "penultimate [] returns Nothing" <|
            \() ->
                penultimate []
                    |> Expect.equal Nothing
        , test "penultimate [a] returns Nothing" <|
            \() ->
                penultimate [ "abc" ]
                    |> Expect.equal Nothing
        , test "penultimate [a, b] returns Just a" <|
            \() ->
                penultimate [ 'a', 'b' ]
                    |> Expect.equal (Just 'a')
        , test "penultimate [a, b, c] returns Just b" <|
            \() ->
                penultimate [ 1.3, 2.4, 3.6 ]
                    |> Expect.equal (Just 2.4)
        , test "penultimate (List.range x y) returns Just (y-1)" <|
            \() ->
                penultimate (List.range 1 1001)
                    |> Expect.equal (Just 1000)
        ]


main : Runner.TestProgram
main =
    Runner.run tests
