-- This module will be imported in ModuleExample.elm


module Hanzi exposing (hanziGenerator)

import Random
import Char
import String


hanziGenerator : Random.Generator String
hanziGenerator =
    let
        generator =
            Random.int 0x4E00 0x9FFF
    in
        Random.map intToString generator


intToString num =
    num |> Char.fromCode |> String.fromChar
