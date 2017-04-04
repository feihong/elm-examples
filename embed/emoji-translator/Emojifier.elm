module Emojifier exposing (emojify, textify)

import Char
import Dict
import List.Extra
import Regex
import Unicode


type alias Key =
    Char


emojify key text =
    convert key True text


textify key text =
    convert key False text


convert key toEmoji text =
    let
        emojis =
            rotateEmojis key availableEmojis

        lists =
            if toEmoji then
                ( letters, emojis )
            else
                ( emojis, letters )

        mapper =
            List.Extra.zip (Tuple.first lists) (Tuple.second lists)
                |> Dict.fromList
                |> Debug.log "mapper"

        lookup char =
            Dict.get char mapper
                |> Maybe.withDefault '?'
    in
        text
            |> Unicode.stringToList
            |> List.map lookup
            |> String.fromList


rotateEmojis : Key -> List Char -> List Char
rotateEmojis key emojis =
    emojis
        |> List.Extra.elemIndex key
        |> Maybe.withDefault 0
        |> \index ->
            List.Extra.splitAt index emojis
                |> \( front, back ) -> List.append back front


unicodeSplit str =
    let
        splitter =
            -- due to JavaScript issues with splitting and unicode, we maually split the string.
            (Regex.regex "([\\uD800-\\uDBFF][\\uDC00-\\uDFFF])")
    in
        Regex.split Regex.All splitter


letters : List Char
letters =
    List.append (List.range 65 90) (List.range 97 122)
        |> List.map Char.fromCode


availableEmojis : List Char
availableEmojis =
    [ -- 1
      '😀'
      -- 2
    , '😁'
      -- 3
    , '😂'
      -- 4
    , '😃'
      -- 5
    , '😄'
      -- 6
    , '😅'
      -- 7
    , '😆'
      -- 8
    , '😇'
      -- 9
    , '😈'
      -- 10
    , '😉'
      -- 11
    , '😊'
      -- 12
    , '😋'
      -- 13
    , '😌'
      -- 14
    , '😍'
      -- 15
    , '😎'
      -- 16
    , '😏'
      -- 17
    , '😐'
      -- 18
    , '😑'
      -- 19
    , '😒'
      -- 20
    , '😓'
      -- 21
    , '😔'
      -- 22
    , '😕'
      -- 23
    , '😖'
      -- 24
    , '😗'
      -- 25
    , '😘'
      -- 26
    , '😙'
      -- 27
    , '😚'
      -- 28
    , '😛'
      -- 29
    , '😜'
      -- 30
    , '😝'
      -- 31
    , '😞'
      -- 32
    , '😟'
      -- 33
    , '😠'
      -- 34
    , '😡'
      -- 35
    , '😢'
      -- 36
    , '😣'
      -- 37
    , '😤'
      -- 38
    , '😥'
      -- 39
    , '😦'
      -- 40
    , '😧'
      -- 41
    , '😨'
      -- 42
    , '😩'
      -- 43
    , '😪'
      -- 44
    , '😫'
      -- 45
    , '😬'
      -- 46
    , '😭'
      -- 47
    , '😮'
      -- 48
    , '😯'
      -- 49
    , '😰'
      -- 50
    , '😱'
      -- 51
    , '😲'
      -- 52
    , '😳'
    ]
