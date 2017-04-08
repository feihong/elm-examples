module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


split : List a -> Int -> ( List a, List a )
split list n =
    ( List.take n list, List.drop n list )



-- split : List a -> Int -> ( List a, List a )
-- split list n =
--     list
--         |> List.foldl
--             (\a ( i, front, back ) ->
--                 if i < n then
--                     ( i + 1, a :: front, back )
--                 else
--                     ( i + 1, front, a :: back )
--             )
--             ( 0, [], [] )
--         |> \( _, front, back ) -> ( List.reverse front, List.reverse back )


tests : Test
tests =
    describe "dropNth"
        [ test "Empty list" <|
            \() ->
                split [] 1
                    |> Expect.equal ( [], [] )
        , test "Single element" <|
            \() ->
                split [ 'a' ] 1
                    |> Expect.equal ( [ 'a' ], [] )
        , test "Single element, n == 2" <|
            \() ->
                split [ 'a' ] 2
                    |> Expect.equal ( [ 'a' ], [] )
        , test "Single element, n == 0" <|
            \() ->
                split [ 'a' ] 0
                    |> Expect.equal ( [], [ 'a' ] )
        , test "Negative n" <|
            \() ->
                split [ 1, 2, 3, 4, 5 ] -1
                    |> Expect.equal ( [], [ 1, 2, 3, 4, 5 ] )
        , test "Seven elements" <|
            \() ->
                split [ "a", "b", "c", "d", "e", "f", "g" ] 3
                    |> Expect.equal
                        ( [ "a", "b", "c" ], [ "d", "e", "f", "g" ] )
        , test "Many elements" <|
            \() ->
                split (List.range 1 100) 43
                    |> \( x, y ) ->
                        ( List.length x, List.length y )
                            |> Expect.equal
                                ( 43, 57 )
        ]


main : Runner.TestProgram
main =
    Runner.run tests
