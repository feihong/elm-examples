module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


type RleCode a
    = Run Int a
    | Single a


rleEncode : List (List a) -> List (RleCode a)
rleEncode lists =
    let
        checkHead list =
            case List.head list of
                Nothing ->
                    Nothing

                Just x ->
                    let
                        len =
                            List.length list
                    in
                        if len == 1 then
                            Just <| Single x
                        else
                            Just <| Run len x
    in
        lists
            |> List.filterMap checkHead


tests : Test
tests =
    describe "rleEncode"
        [ test "Empty list" <|
            \() ->
                rleEncode []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                rleEncode [ [ 'a' ] ]
                    |> Expect.equal [ Single 'a' ]
        , test "Three elements" <|
            \() ->
                rleEncode [ [ 1, 1, 1 ], [ 2, 2 ], [ 3 ] ]
                    |> Expect.equal [ Run 3 1, Run 2 2, Single 3 ]
        , test "Many elements" <|
            \() ->
                rleEncode [ [ "a", "a", "a", "a" ], [ "b" ], [ "c", "c" ], [ "b" ], [ "a" ] ]
                    |> Expect.equal
                        [ Run 4 "a"
                        , Single "b"
                        , Run 2 "c"
                        , Single "b"
                        , Single "a"
                        ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
