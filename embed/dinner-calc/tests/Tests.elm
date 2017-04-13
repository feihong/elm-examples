module Tests exposing (..)

import Test exposing (..)
import Expect
import Test.Runner.Html as Runner
import TestHelpers


tests : Test
tests =
    describe "Dinner Calculator tests"
        [ TestHelpers.tests ]


main : Runner.TestProgram
main =
    Runner.run tests
