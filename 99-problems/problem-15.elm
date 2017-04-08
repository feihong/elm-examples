module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


{-| Note how we leave off the last argument for List.concatMap
-}
repeatElements : Int -> List a -> List a
repeatElements length =
    List.concatMap (\x -> List.repeat length x)



-- repeatElements : Int -> List a -> List a
-- repeatElements length list =
--     case list of
--         [] ->
--             []
--         x :: xs ->
--             (List.repeat length x) ++ repeatElements length xs


tests : Test
tests =
    describe "repeatElements"
        [ test "Empty list" <|
            \() ->
                repeatElements 5 []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                repeatElements 2 [ 'a' ]
                    |> Expect.equal [ 'a', 'a' ]
        , test "Single element" <|
            \() ->
                repeatElements 0 [ 'a' ]
                    |> Expect.equal []
        , test "Three elements" <|
            \() ->
                repeatElements 5 [ "a", "b", "c" ]
                    |> Expect.equal
                        [ "a", "a", "a", "a", "a", "b", "b", "b", "b", "b", "c", "c", "c", "c", "c" ]
        , test "Three elements" <|
            \() ->
                repeatElements -1 [ "a", "b", "c" ]
                    |> Expect.equal []
        , test "Many elements" <|
            \() ->
                repeatElements 3 [ 1, 2, 3, 5, 8, 8 ]
                    |> Expect.equal
                        [ 1, 1, 1, 2, 2, 2, 3, 3, 3, 5, 5, 5, 8, 8, 8, 8, 8, 8 ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
