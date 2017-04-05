module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


runLengths : List (List a) -> List ( Int, a )
runLengths lists =
    lists
        |> List.filterMap
            (\list ->
                case List.head list of
                    Nothing ->
                        Nothing

                    Just x ->
                        Just ( List.length list, x )
            )


tests : Test
tests =
    describe "runLengths"
        [ test "Empty list" <|
            \() ->
                runLengths []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                runLengths [ [ 'a' ] ]
                    |> Expect.equal [ ( 1, 'a' ) ]
        , test "Three elements" <|
            \() ->
                runLengths [ [ 1, 1, 1 ], [ 2, 2 ], [ 3 ] ]
                    |> Expect.equal [ ( 3, 1 ), ( 2, 2 ), ( 1, 3 ) ]
        , test "Many elements" <|
            \() ->
                runLengths [ [ "a", "a", "a", "a" ], [ "b" ], [ "c", "c" ], [ "b" ], [ "a" ] ]
                    |> Expect.equal
                        [ ( 4, "a" )
                        , ( 1, "b" )
                        , ( 2, "c" )
                        , ( 1, "b" )
                        , ( 1, "a" )
                        ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
