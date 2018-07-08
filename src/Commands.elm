module Commands exposing (fetchGame)

import Http
import RemoteData
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)

import Messages exposing (..)
import Models exposing (Game, TeamData)


fetchGame : String -> Cmd Msg
fetchGame gameId =
    case gameId of
        "" ->
            Cmd.none

        gameId ->
            Http.get (fetchGameUrl gameId) gameDecoder
                |> RemoteData.sendRequest
                |> Cmd.map OnFetchGame

-- PRIVATE

fetchGameUrl : String -> String
fetchGameUrl gameId =
    "http://localhost:8080/games/" ++ gameId

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
