{- This module serves as an interface for a native module. -}


module MyModule exposing (..)

import Native.MyModule


add : number -> number -> number -> number
add a b c =
    Native.MyModule.add a b c


unicodeStringToList : String -> List Char
unicodeStringToList =
    Native.MyModule.unicodeStringToList
