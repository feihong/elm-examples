module Tests exposing (..)

import Test exposing (..)
import Expect
import Test.Runner.Html as Runner
import TestCalculate
import TestUtil


tests : Test
tests =
    describe "All tests"
        [ TestCalculate.tests
        , TestUtil.tests
        ]


main : Runner.TestProgram
main =
    Runner.run tests
