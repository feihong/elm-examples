module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


dropAt : Int -> List a -> List a
dropAt n list =
    let
        front =
            List.take (n - 1) list

        back =
            List.drop n list
    in
        front ++ back



-- dropAt : Int -> List a -> List a
-- dropAt n list =
--     list
--         |> List.indexedMap
--             (\i a ->
--                 if (i + 1) == n then
--                     []
--                 else
--                     [ a ]
--             )
--         |> List.concat


tests : Test
tests =
    describe "dropNth"
        [ test "Empty list" <|
            \() ->
                dropAt 1 []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                dropAt 1 [ 'a' ]
                    |> Expect.equal []
        , test "Single element, n == 2" <|
            \() ->
                dropAt 2 [ 'a' ]
                    |> Expect.equal [ 'a' ]
        , test "n == -1" <|
            \() ->
                dropAt -1 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 1, 2, 3, 4, 5 ]
        , test "n == 0" <|
            \() ->
                dropAt 0 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 1, 2, 3, 4, 5 ]
        , test "n > list length" <|
            \() ->
                dropAt 6 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 1, 2, 3, 4, 5 ]
        , test "Many elements" <|
            \() ->
                dropAt 12 (List.range 1 30)
                    |> Expect.equal ((List.range 1 11) ++ (List.range 13 30))
        ]


main : Runner.TestProgram
main =
    Runner.run tests
