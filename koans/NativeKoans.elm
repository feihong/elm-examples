module NativeKoans exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner
import MyModule


tests : Test
tests =
    describe "Native koans"
        [ test "add" <|
            \() ->
                MyModule.add 3 4 5
                    |> Expect.equal 12
        , test "unicodeStringToList" <|
            \() ->
                "😀😁😂"
                    |> MyModule.unicodeStringToList
                    |> Expect.equal [ '😀', '😁', '😂' ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
