module Main exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


reverse : List a -> List a
reverse list =
    List.foldl (::) [] list



-- reverse : List a -> List a
-- reverse list =
--     List.foldl (\a b -> a :: b) [] list
-- reverse : List a -> List a
-- reverse list =
--     case list of
--         [] ->
--             []
--         head :: tail ->
--             reverse tail ++ [ head ]


tests : Test
tests =
    describe "reverse"
        [ test "Empty list" <|
            \() ->
                reverse []
                    |> Expect.equal []
        , test "Single element" <|
            \() ->
                reverse [ "abc" ]
                    |> Expect.equal [ "abc" ]
        , test "Three elements" <|
            \() ->
                reverse [ 'a', 'b', 'c' ]
                    |> Expect.equal [ 'c', 'b', 'a' ]
        , test "Many elements" <|
            \() ->
                let
                    expected =
                        (List.range 1 1000)
                            |> List.map (\n -> 1000 - n + 1)
                in
                    List.range 1 1000
                        |> reverse
                        |> Expect.equal expected
        ]


main : Runner.TestProgram
main =
    Runner.run tests
