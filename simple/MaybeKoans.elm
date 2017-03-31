module MaybeKoans exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner


tests : Test
tests =
    describe "Maybe koans"
        [ test "Maybe.withDefault" <|
            \() ->
                Maybe.withDefault 666 (Just 4)
                    |> Expect.equal 4
        , test "Maybe.withDefault" <|
            \() ->
                Maybe.withDefault 666 (Nothing)
                    |> Expect.equal 666
        , test "Maybe.map" <|
            \() ->
                Just 7
                    |> Maybe.map (\x -> x + 5 |> toString)
                    |> Expect.equal (Just "12")
        , test "Maybe.map" <|
            \() ->
                Nothing
                    |> Maybe.map (\x -> x + 5 |> toString)
                    |> Expect.equal Nothing
        , test "Maybe.andThen" <|
            \() ->
                Just 7
                    |> Maybe.andThen
                        (\x ->
                            if x < 10 then
                                Just x
                            else
                                Nothing
                        )
                    |> Maybe.andThen (toString >> Just)
                    |> Expect.equal (Just "7")
        , test "Maybe.andThen" <|
            \() ->
                Just 12
                    |> Maybe.andThen
                        (\x ->
                            if x < 10 then
                                Just x
                            else
                                Nothing
                        )
                    |> Maybe.andThen (toString >> Just)
                    |> Expect.equal Nothing
        ]


main : Runner.TestProgram
main =
    Runner.run tests
