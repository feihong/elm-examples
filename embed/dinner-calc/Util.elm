module Util exposing (..)


stringIsNotEmpty =
    not << String.isEmpty


noCmd model =
    model ! []
