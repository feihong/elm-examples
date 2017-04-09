module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


rotate : Int -> List a -> List a
rotate n list =
    if List.length list == 0 then
        list
    else
        let
            splitNum =
                n % List.length list
        in
            (List.drop splitNum list) ++ (List.take splitNum list)


tests : Test
tests =
    describe "rotate"
        [ test "Empty list" <|
            \() ->
                rotate 1 []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                rotate 6 [ 'a' ]
                    |> Expect.equal [ 'a' ]
        , test "n == 3" <|
            \() ->
                rotate 3 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 4, 5, 1, 2, 3 ]
        , test "n == 8" <|
            \() ->
                rotate 8 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 4, 5, 1, 2, 3 ]
        , test "n == 5" <|
            \() ->
                rotate 5 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 1, 2, 3, 4, 5 ]
        , test "n == -3" <|
            \() ->
                rotate -3 [ 1, 2, 3, 4, 5 ]
                    |> Expect.equal [ 3, 4, 5, 1, 2 ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
