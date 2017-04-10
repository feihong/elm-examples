module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


insertAt : Int -> a -> List a -> List a
insertAt n newValue list =
    let
        front =
            List.take (n - 1) list

        back =
            List.drop (n - 1) list
    in
        front ++ (newValue :: back)


tests : Test
tests =
    describe "insertAt"
        [ test "Empty list" <|
            \() ->
                insertAt 1 99 []
                    |> Expect.equal [ 99 ]
        , test "Single element" <|
            \() ->
                insertAt 1 'b' [ 'a' ]
                    |> Expect.equal [ 'b', 'a' ]
        , test "Single element, n == 2" <|
            \() ->
                insertAt 2 'b' [ 'a' ]
                    |> Expect.equal [ 'a', 'b' ]
        , test "n == -1" <|
            \() ->
                insertAt -1 99 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 99, 1, 2, 3, 4, 5 ]
        , test "n == 0" <|
            \() ->
                insertAt 0 99 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 99, 1, 2, 3, 4, 5 ]
        , test "n > list length" <|
            \() ->
                insertAt 6 99 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 1, 2, 3, 4, 5, 99 ]
        , test "Many elements" <|
            \() ->
                insertAt 12 99 (List.range 1 30)
                    |> Expect.equal ((List.range 1 11) ++ [ 99 ] ++ (List.range 12 30))
        ]


main : Runner.TestProgram
main =
    Runner.run tests
