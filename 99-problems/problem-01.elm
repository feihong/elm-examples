module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


last : List a -> Maybe a
last list =
    case list of
        [] ->
            Nothing

        head :: [] ->
            Just head

        _ :: tail ->
            last tail



-- last : List a -> Maybe a
-- last =
--     List.reverse >> List.head


tests : Test
tests =
    describe "last"
        [ test "last [] returns Nothing" <|
            \() ->
                last []
                    |> Expect.equal Nothing
        , test "last [111] returns Just 111" <|
            \() ->
                last [ "abc" ]
                    |> Expect.equal (Just "abc")
        , test "last (List.range 1 1001) returns Just 1001" <|
            \() ->
                last (List.range 1 1001)
                    |> Expect.equal (Just 1001)
        ]


main : Runner.TestProgram
main =
    Runner.run tests
