module Msgs exposing (..)

import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Http
import Models exposing (Player)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)
