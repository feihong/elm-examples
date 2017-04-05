module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


type NestedList a
    = Elem a
    | SubList (List (NestedList a))


flatten : NestedList a -> List a
flatten nl =
    case nl of
        Elem x ->
            [ x ]

        SubList list ->
            List.concatMap flatten list



-- flatten : NestedList a -> List a
-- flatten nl =
--     case nl of
--         Elem x ->
--             [ x ]
--         SubList list ->
--             List.foldl (\a b -> b ++ flatten a) [] list


nl0 =
    SubList
        [ Elem 1
        , SubList
            [ SubList
                [ Elem 2
                , SubList [ Elem 3, Elem 4 ]
                ]
            , Elem 5
            ]
        , Elem 6
        , SubList [ Elem 7, Elem 8, Elem 9 ]
        ]


tests : Test
tests =
    describe "flatten"
        [ test "Empty" <|
            \() ->
                SubList []
                    |> flatten
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                Elem 'a'
                    |> flatten
                    |> Expect.equal [ 'a' ]
        , test "Three elements" <|
            \() ->
                SubList [ Elem 1, Elem 2, Elem 3, Elem 4 ]
                    |> flatten
                    |> Expect.equal [ 1, 2, 3, 4 ]
        , test "Complex" <|
            \() ->
                nl0
                    |> flatten
                    |> Expect.equal [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
