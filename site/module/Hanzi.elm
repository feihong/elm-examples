module Hanzi exposing (hanzi)

import Random
import Char
import String


hanzi : Random.Generator String
hanzi = Random.map (\x -> x |> Char.fromCode |> String.fromChar) (Random.int 0x4e00 0x9fff)
