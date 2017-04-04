module Unicode exposing (..)

import Native.Unicode


stringToList : String -> List Char
stringToList =
    Native.Unicode.stringToList
