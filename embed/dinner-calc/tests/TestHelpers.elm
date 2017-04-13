module TestHelpers exposing (..)

import Test exposing (..)
import Expect
import Test.Runner.Html as Runner


tests : Test
tests =
    describe "Helper tests"
        [ test "woo" <|
            \() ->
                True |> Expect.equal True
        ]
