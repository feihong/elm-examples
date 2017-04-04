module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


elementAt : List a -> Int -> Maybe a
elementAt list index =
    case list of
        [] ->
            Nothing

        head :: tail ->
            if index == 1 then
                Just head
            else
                elementAt tail (index - 1)



-- elementAt : List a -> Int -> Maybe a
-- elementAt list index =
--     case list of
--         [] ->
--             Nothing
--         _ ->
--             if index < 1 then
--                 Nothing
--             else
--                 List.drop (index - 1) list
--                     |> List.head


tests : Test
tests =
    describe "elementAt"
        [ test "Empty list" <|
            \() ->
                [ -1, 0, 1, 2 ]
                    |> List.map (\index -> elementAt [] index)
                    |> Expect.equal [ Nothing, Nothing, Nothing, Nothing ]
        , test "Single element" <|
            \() ->
                [ -1, 0, 1, 2 ]
                    |> List.map (\index -> elementAt [ "abc" ] index)
                    |> Expect.equal [ Nothing, Nothing, Just "abc", Nothing ]
        , test "Three elements" <|
            \() ->
                [ 0, 1, 2, 3, 4 ]
                    |> List.map (\index -> elementAt [ 'a', 'b', 'c' ] index)
                    |> Expect.equal [ Nothing, Just 'a', Just 'b', Just 'c', Nothing ]
        , test "Many elements" <|
            \() ->
                [ 1, 15, 600, 1000, 1001 ]
                    |> List.map (\index -> elementAt (List.range 1 1000) index)
                    |> Expect.equal [ Just 1, Just 15, Just 600, Just 1000, Nothing ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
