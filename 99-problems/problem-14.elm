module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


{-| Note how we leave off the last argument for List.concatMap
-}
duplicate : List a -> List a
duplicate =
    List.concatMap (\n -> [ n, n ])



-- duplicate : List a -> List a
-- duplicate list =
--     case list of
--         [] ->
--             []
--         x :: xs ->
--             x :: x :: duplicate xs


tests : Test
tests =
    describe "duplicate"
        [ test "Empty list" <|
            \() ->
                duplicate []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                duplicate [ 'a' ]
                    |> Expect.equal [ 'a', 'a' ]
        , test "Three elements" <|
            \() ->
                duplicate [ "a", "b", "c" ]
                    |> Expect.equal [ "a", "a", "b", "b", "c", "c" ]
        , test "Many elements" <|
            \() ->
                duplicate [ 1, 2, 3, 5, 8, 8 ]
                    |> Expect.equal [ 1, 1, 2, 2, 3, 3, 5, 5, 8, 8, 8, 8 ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
