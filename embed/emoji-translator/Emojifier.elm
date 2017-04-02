module Emojifier exposing (emojify)

import Char
import Array exposing (Array)


emojify : String -> String
emojify text =
    text
        |> String.toList
        |> List.map toEmoji
        |> List.map (Maybe.withDefault '?')
        |> String.fromList


toEmoji c =
    let
        code =
            Char.toCode c
    in
        if c >= 'A' && c <= 'Z' then
            Array.get (code - 65) availableEmojis
        else if c >= 'a' && c <= 'z' then
            Array.get (code - 71) availableEmojis
        else
            Just c


availableEmojis : Array Char
availableEmojis =
    Array.fromList
        [ '😀'
        , '😁'
        , '😂'
        , '😃'
        , '😄'
        , '😅'
        , '😆'
        , '😇'
        , '😈'
        , '😉'
        , '😊'
        , '😋'
        , '😌'
        , '😍'
        , '😎'
        , '😏'
        , '😐'
        , '😑'
        , '😒'
        , '😓'
        , '😔'
        , '😕'
        , '😖'
        , '😗'
        , '😘'
        , '😙'
        , '😚'
        , '😛'
        , '😜'
        , '😝'
        , '😞'
        , '😟'
        , '😠'
        , '😡'
        , '😢'
        , '😣'
        , '😤'
        , '😥'
        , '😦'
        , '😧'
        , '😨'
        , '😩'
        , '😪'
        , '😫'
        , '😬'
        , '😭'
        , '😮'
        , '😯'
        , '😰'
        , '😱'
        , '😲'
        , '😳'
        , '😴'
        ]
