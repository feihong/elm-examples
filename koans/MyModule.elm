module MyModule exposing (..)

import Native.MyModule


add : number -> number -> number -> number
add a b c =
    Native.MyModule.add a b c


stringToList : String -> List Char
stringToList =
    Native.MyModule.stringToList
