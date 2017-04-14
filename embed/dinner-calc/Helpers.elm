module Helpers exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Models exposing (..)


type alias Money =
    Int


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
        isComplex =
            model.items
                |> List.any (\item -> item.payer /= Group)
    in
        if isComplex then
            calculateComplex model
        else
            calculateSimple model


calculateBasics : Model -> ( Money, Money, Money, Money )
calculateBasics model =
    let
        subtotal =
            model.items
                |> List.map .amount
                |> List.sum

        tip =
            subtotal
                |> toFloat
                |> (*) (model.tipPercent / 100)
                |> round

        tax =
            subtotal
                |> toFloat
                |> (*) (model.taxPercent / 100)
                |> round

        total =
            subtotal + tip + tax
    in
        ( subtotal, tip, tax, total )


calculateSimple : Model -> Calculation
calculateSimple model =
    let
        ( subtotal, tip, tax, total ) =
            calculateBasics model

        amount =
            (toFloat total)
                / (toFloat model.groupSize)
                |> ceiling
    in
        { subtotal = subtotal
        , tax = tax
        , tip = tip
        , total = total
        , breakdown = EveryonePays amount
        }


calculateComplex : Model -> Calculation
calculateComplex model =
    let
        ( subtotal, tax, tip, total ) =
            calculateBasics model
    in
        { subtotal = subtotal
        , tax = tax
        , tip = tip
        , total = total
        , breakdown = calculateComplexBreakdown model subtotal total
        }


calculateComplexBreakdown : Model -> Money -> Money -> Breakdown
calculateComplexBreakdown model subtotal total =
    let
        scalingFactor =
            (toFloat total) / (toFloat subtotal)

        sharedAmount =
            model.items
                |> List.filter (\item -> item.payer == Group)
                |> List.map .amount
                |> List.sum
                |> toFloat
                |> flip (/) (toFloat model.groupSize)
                |> (*) scalingFactor

        -- Incrementally add up amounts for each individual payer
        updateDict item dict =
            case item.payer of
                Attendee name ->
                    updateAdd name item.amount dict

                Group ->
                    dict

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
