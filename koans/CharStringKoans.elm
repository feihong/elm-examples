module CharStringKoans exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Test.Runner.Html as Runner
import Char
import Regex


{-| Due to JavaScript issues with splitting and unicode, we have to split using
a regex.

Source: https://mathiasbynens.be/notes/javascript-unicode
-}
splitRegex : Regex.Regex
splitRegex =
    Regex.regex "([\\uD800-\\uDBFF][\\uDC00-\\uDFFF])"


unicodeSplit : String -> List String
unicodeSplit text =
    Regex.split Regex.All splitRegex text
        -- Split produces some empty strings, which we filter out
        |>
            List.filter (String.isEmpty >> not)


tests : Test
tests =
    describe "Char & String koans"
        [ test "String.toList" <|
            \() ->
                "上班也混混"
                    |> String.toList
                    |> Expect.equal [ '上', '班', '也', '混', '混' ]
        , test "String.toList has trouble with high code point characters" <|
            \() ->
                "😀😁😂"
                    |> String.toList
                    |> Expect.notEqual [ '😀', '😁', '😂' ]
        , test "String.fromList" <|
            \() ->
                [ '😀', '😁', '😂' ]
                    |> String.fromList
                    |> Expect.equal "😀😁😂"
        , test "Char.toCode" <|
            \() ->
                '算'
                    |> Char.toCode
                    |> Expect.equal 31639
        , test "Char.toCode is unable to handle high code point characters" <|
            \() ->
                -- The underlying implementation uses String.charCodeAt()
                -- instead of String.codePointAt().
                '😀'
                    |> Char.toCode
                    |> Expect.notEqual 0x0001F600
        , test "Char.fromCode" <|
            \() ->
                31639
                    |> Char.fromCode
                    |> Expect.equal '算'
        , test "unicodeSplit" <|
            \() ->
                "😀😁😂"
                    |> unicodeSplit
                    |> Expect.equal [ "😀", "😁", "😂" ]
        ]


main : Runner.TestProgram
main =
    Runner.run tests
