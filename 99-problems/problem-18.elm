module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner
import Array


slice : Int -> Int -> List a -> List a
slice start end list =
    let
        len =
            List.length list

        start_ =
            clamp 1 len start

        end_ =
            clamp 1 len end
    in
        list
            |> List.drop (start_ - 1)
            |> List.take (end_ - start_ + 1)



-- slice : Int -> Int -> List a -> List a
-- slice start end list =
--     let
--         len =
--             List.length list
--         start_ =
--             clamp 1 len start
--         end_ =
--             clamp 1 len end
--     in
--         list
--             |> Array.fromList
--             |> Array.slice (start_ - 1) end_
--             |> Array.toList


tests : Test
tests =
    describe "slice"
        [ test "Empty list" <|
            \() ->
                slice 1 2 []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                slice 1 1 [ 'a' ]
                    |> Expect.equal [ 'a' ]
        , test "Single element, start == 0" <|
            \() ->
                slice 0 4 [ 'a' ]
                    |> Expect.equal [ 'a' ]
        , test "Negative n" <|
            \() ->
                slice -7 8 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 1, 2, 3, 4, 5 ]
        , test "Start and end out of order" <|
            \() ->
                slice 4 1 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal []
        , test "Seven elements" <|
            \() ->
                slice 3 6 [ "a", "b", "c", "d", "e", "f", "g" ]
                    |> Expect.equal
                        [ "c", "d", "e", "f" ]
        , test "Many elements" <|
            \() ->
                slice 22 89 (List.range 1 100)
                    |> Array.fromList
                    |> \arr ->
                        ( Array.length arr, Array.get 0 arr, Array.get 67 arr )
                            |> Expect.equal ( 68, Just 22, Just 89 )
        ]


main : Runner.TestProgram
main =
    Runner.run tests
