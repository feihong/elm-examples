module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import RemoteData exposing (WebData)
import Models exposing (..)
import Msgs exposing (Msg)


fetchPlayers : Cmd Msg
fetchPlayers =
    Http.get "/api/players/" playersDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchPlayers


playerDecoder : Decode.Decoder Player
playerDecoder =
    decode Player
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "level" Decode.int


playersDecoder : Decode.Decoder (List Player)
playersDecoder =
    Decode.list playerDecoder


playerEncoder : Player -> Encode.Value
playerEncoder player =
    [ ( "id", Encode.string player.id )
    , ( "name", Encode.string player.name )
    , ( "level", Encode.int player.level )
    ]
        |> Encode.object


savePlayerUrl : PlayerId -> String
savePlayerUrl playerId =
    "/api/players/" ++ playerId


savePlayerCmd : Player -> Cmd Msg
savePlayerCmd player =
    let
        savePlayerRequest player =
            Http.request
                { body = playerEncoder player |> Http.jsonBody
                , expect = Http.expectJson playerDecoder
                , headers = []
                , method = "PATCH"
                , timeout = Nothing
                , url = savePlayerUrl player.id
                , withCredentials = False
                }
    in
        player
            |> savePlayerRequest
            |> Http.send Msgs.OnPlayerSave
