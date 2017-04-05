module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


pack : List a -> List (List a)
pack list =
    let
        packer x acc =
            case acc of
                [] ->
                    [ [ x ] ]

                headList :: lists ->
                    case List.head headList of
                        -- Should not be able to get here
                        Nothing ->
                            [ [ x ] ]

                        Just head ->
                            if x == head then
                                (x :: headList) :: lists
                            else
                                [ x ] :: acc
    in
        List.foldr packer [] list


tests : Test
tests =
    describe "pack"
        [ test "Empty list" <|
            \() ->
                pack []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                pack [ 'a' ]
                    |> Expect.equal [ [ 'a' ] ]
        , test "Three elements" <|
            \() ->
                pack [ 1, 1, 2 ]
                    |> Expect.equal [ [ 1, 1 ], [ 2 ] ]
        , test "Three elements" <|
            \() ->
                pack [ 1, 1, 1 ]
                    |> Expect.equal [ List.repeat 3 1 ]
        , test "Three elements" <|
            \() ->
                pack [ 1, 2, 1 ]
                    |> Expect.equal [ [ 1 ], [ 2 ], [ 1 ] ]
        , test "Many elements" <|
            \() ->
                pack [ 1, 1, 1, 2, 3, 3, 3, 4, 4, 4, 4, 5, 6, 6 ]
                    |> Expect.equal
                        [ [ 1, 1, 1 ]
                        , [ 2 ]
                        , List.repeat 3 3
                        , List.repeat 4 4
                        , [ 5 ]
                        , [ 6, 6 ]
                        ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
