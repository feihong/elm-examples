module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


length : List a -> Int
length list =
    List.foldl (\_ b -> b + 1) 0 list



-- length : List a -> Int
-- length list =
--     list
--         |> List.map (\_ -> 1)
--         |> List.sum
-- length : List a -> Int
-- length list =
--     case list of
--         [] ->
--             0
--         _ :: tail ->
--             1 + (length tail)


tests : Test
tests =
    describe "length"
        [ test "Empty list" <|
            \() ->
                length []
                    |> Expect.equal 0
        , test "Single element" <|
            \() ->
                length [ "abc" ]
                    |> Expect.equal 1
        , test "Three elements" <|
            \() ->
                length [ 0, 1, 2 ]
                    |> Expect.equal 3
        , test "Many elements" <|
            \() ->
                List.range 1 1000
                    |> length
                    |> Expect.equal 1000
        ]


main : Runner.TestProgram
main =
    Runner.run tests
