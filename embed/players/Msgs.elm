module Msgs exposing (..)

import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Models exposing (Player)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
