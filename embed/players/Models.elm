module Models exposing (..)

import RemoteData exposing (WebData)


type alias PlayerId =
    String


type alias Player =
    { id : PlayerId
    , name : String
    , level : Int
    }


type alias Model =
    { response : WebData (List Player)
    }


type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NotFoundRoute


initialModel : Model
initialModel =
    { response = RemoteData.Loading
    }
