module Commands exposing (fetchGame)

import Http
import RemoteData
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)

import Messages exposing (..)
import Models exposing (Game, TeamData)


fetchGame : Cmd Msg
fetchGame =
    Http.get fetchGameUrl gameDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchGame

fetchGameUrl : String
fetchGameUrl =
    "http://localhost:8080/games/1"

gameDecoder : Decode.Decoder Game
gameDecoder =
    decode Game
        |> Json.Decode.Pipeline.required "teamA" teamDecoder
        |> Json.Decode.Pipeline.required "teamB" teamDecoder

teamDecoder : Decode.Decoder TeamData
teamDecoder =
    decode TeamData
        |> Json.Decode.Pipeline.required "name" Decode.string
        |> Json.Decode.Pipeline.required "score" Decode.int
