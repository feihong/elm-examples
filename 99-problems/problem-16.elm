module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


{-| You could also use List.concatMap for a very similar solution.
-}
dropNth : List a -> Int -> List a
dropNth list n =
    if n <= 0 then
        list
    else
        list
            |> List.indexedMap
                (\i a ->
                    if (i + 1) % n == 0 then
                        Nothing
                    else
                        Just a
                )
            |> List.filterMap identity



-- dropNth : List a -> Int -> List a
-- dropNth list n =
--     if n <= 0 then
--         list
--     else
--         list
--             |> List.foldl
--                 (\x ( i, xs ) ->
--                     if (i + 1) % n == 0 then
--                         ( i + 1, xs )
--                     else
--                         ( i + 1, x :: xs )
--                 )
--                 ( 0, [] )
--             |> Tuple.second
--             |> List.reverse


tests : Test
tests =
    describe "dropNth"
        [ test "Empty list" <|
            \() ->
                dropNth [] 3
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                dropNth [ 'a' ] 1
                    |> Expect.equal []
        , test "Single element, n == 2" <|
            \() ->
                dropNth [ 'a' ] 2
                    |> Expect.equal [ 'a' ]
        , test "Negative n" <|
            \() ->
                dropNth [ 1, 2, 3, 4, 5 ] -1
                    |> Expect.equal [ 1, 2, 3, 4, 5 ]
        , test "n == 0" <|
            \() ->
                dropNth [ 1, 2, 3, 4, 5 ] 0
                    |> Expect.equal [ 1, 2, 3, 4, 5 ]
        , test "Seven elements" <|
            \() ->
                dropNth [ "a", "b", "c", "d", "e", "f", "g" ] 3
                    |> Expect.equal
                        [ "a", "b", "d", "e", "g" ]
        , test "Many elements" <|
            \() ->
                dropNth (List.range 1 30) 7
                    |> Expect.equal
                        [ 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 22, 23, 24, 25, 26, 27, 29, 30 ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
