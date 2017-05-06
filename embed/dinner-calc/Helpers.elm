module Helpers exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Models exposing (..)


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


calculate : Model -> Calculation
calculate model =
    let
        isSimple =
            List.isEmpty model.items
    in
        if isSimple then
            calculateSimple model
        else
            calculateComplex model


calculateBasics : Model -> ( Money, Money, Money, Int )
calculateBasics { tipPercent, taxPercent, subtotal, attendees } =
    let
        tip =
            subtotal
                |> toFloat
                |> (*) (tipPercent / 100)
                |> round

        tax =
            subtotal
                |> toFloat
                |> (*) (taxPercent / 100)
                |> round

        total =
            subtotal + tip + tax

        groupSize =
            attendees |> List.length
    in
        ( tip, tax, total, groupSize )


calculateSimple : Model -> Calculation
calculateSimple model =
    let
        ( tip, tax, total, groupSize ) =
            calculateBasics model

        amount =
            ((toFloat total) / (toFloat groupSize))
                |> ceiling
    in
        { tax = tax
        , tip = tip
        , total = total
        , breakdown = EveryonePays amount
        }


calculateComplex : Model -> Calculation
calculateComplex model =
    let
        ( tip, tax, total, groupSize ) =
            calculateBasics model
    in
        { tax = tax
        , tip = tip
        , total = total
        , breakdown = calculateComplexBreakdown model groupSize total
        }


calculateComplexBreakdown : Model -> Int -> Money -> Breakdown
calculateComplexBreakdown model groupSize total =
    let
        scalingFactor =
            (toFloat total) / (toFloat model.subtotal)

        -- Sum of individual item amounts
        itemsSum =
            model.items
                |> List.map .amount
                |> List.sum

        -- Cost of group items, split up among all attendees
        sharedAmount =
            (model.subtotal - itemsSum)
                |> toFloat
                |> flip (/) (toFloat groupSize)
                |> (*) scalingFactor

        -- Add individual item price to attendee's total
        updateDict item dict =
            updateAdd item.attendee item.amount dict

        -- Scale the computed amount and add the shared amount
        updateAmount amt =
            amt
                |> toFloat
                |> (*) scalingFactor
                |> (+) sharedAmount
                |> ceiling
    in
        model.items
            |> List.foldl updateDict Dict.empty
            |> Dict.toList
            |> List.map (\( name, amt ) -> ( name, updateAmount amt ))
            |> \list -> ComplexBreakdown list (ceiling sharedAmount)


{-| Update the value at the given key. If there is already a value there, add
the new value to the old value.
-}
updateAdd : String -> number -> Dict String number -> Dict String number
updateAdd key newValue dict =
    dict
        |> Dict.update key
            (\old ->
                case old of
                    Nothing ->
                        Just newValue

                    Just oldValue ->
                        Just <| oldValue + newValue
            )
