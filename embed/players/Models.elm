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
    , route : Route
    }


type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NotFoundRoute


initialModel : Route -> Model
initialModel route =
    { response = RemoteData.Loading
    , route = route
    }
