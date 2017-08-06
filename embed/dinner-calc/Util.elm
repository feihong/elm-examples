module Util exposing (..)

import Dict
import Json.Decode exposing (..)
import Models exposing (..)


stringIsNotEmpty =
    not << String.isEmpty


stringToPercent : String -> Result String Float
stringToPercent text =
    let
        result =
            decodeString float text
    in
        case result of
            Ok value ->
                if value <= 0 then
                    Err "Zero or negative not allowed"
                else if value > 100 then
                    Err "Greater than 100 not allowed"
                else
                    Ok value

            Err err ->
                Err "Not a valid percent value"


stringToInt : String -> Result String Int
stringToInt text =
    let
        result =
            decodeString int text
    in
        case result of
            Ok value ->
                if value <= 1 then
                    Err "Must be greater than 1"
                else
                    Ok value

            Err err ->
                Err "Not a valid integer"


{-| Convert string to money (int)
-}
stringToCents : String -> Result String Int
stringToCents text =
    let
        convert f =
            round (f * 100)
    in
        case decodeString (map convert float) text of
            Err _ ->
                Err "Not a valid value for currency"

            result ->
                result


centsToString : Money -> String
centsToString value =
    let
        dollars =
            value // 100

        cents =
            rem value 100
    in
        toString dollars
            |> flip (++) "."
            |> flip String.append
                (if cents < 10 then
                    "0" ++ toString cents
                 else
                    toString cents
                )


noCmd model =
    model ! []


type alias Counter =
    Dict.Dict String Int


add : String -> Int -> Counter -> Counter
add key value counter =
    counter
        |> Dict.update key
            (\maybeVal ->
                case maybeVal of
                    Just oldValue ->
                        Just <| oldValue + value

                    Nothing ->
                        Just value
            )
