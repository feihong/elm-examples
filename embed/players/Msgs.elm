module Msgs exposing (..)

import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Models exposing (..)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
