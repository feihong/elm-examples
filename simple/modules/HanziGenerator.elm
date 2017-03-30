-- This module will be imported in ModuleExample.elm


module HanziGenerator exposing (hanziGenerator)

import Random
import Char
import String


{- Generate a random Chinese character. Usage:

   Random.generate NewHanzi hanziGenerator
-}


hanziGenerator : Random.Generator String
hanziGenerator =
    let
        generator =
            Random.int 0x4E00 0x9FFF
    in
        Random.map intToString generator


intToString : Int -> String
intToString num =
    num |> Char.fromCode |> String.fromChar
