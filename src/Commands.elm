module Commands exposing (fetchGame, saveGame)

import Http
import RemoteData
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode

import Messages exposing (..)
import Models exposing (Auth, Game, TeamData)


fetchGame : String -> Cmd Msg
fetchGame gameId =
    case gameId of
        "" ->
            Cmd.none

        gameId ->
            Http.get (fetchGameUrl gameId) gameDecoder
                |> RemoteData.sendRequest
                |> Cmd.map OnFetchGame

saveGame : Game -> Auth -> Cmd Msg
saveGame game auth =
    case auth.accessToken of
        "" ->
            Cmd.none

        _ ->
            let
                htppMethod = case game.id of
                    "" ->
                        "POST"

                    _ ->
                        "PATCH"
            in
                Http.request
                    { method = htppMethod
                    , headers =
                        [ Http.header "Accept" "application/json"
                        , Http.header "Authorization" ("Token " ++ auth.accessToken)
                        ]
                    , url = (fetchGameUrl game.id)
                    , body = Http.jsonBody (gameEncoder game)
                    , expect = Http.expectJson gameDecoder
                    , timeout = Nothing
                    , withCredentials = False
                    }
                    |> RemoteData.sendRequest
                    |> Cmd.map OnSaveGame

-- PRIVATE

fetchGameUrl : String -> String
fetchGameUrl gameId =
    "http://localhost:3030/broadcasts/" ++ gameId

gameDecoder : Decode.Decoder Game
gameDecoder =
    decode Game
        |> required "_id" Decode.string
        |> required "teamA" teamDecoder
        |> required "teamB" teamDecoder

teamDecoder : Decode.Decoder TeamData
teamDecoder =
    decode TeamData
        |> required "name" Decode.string
        |> required "score" Decode.int

gameEncoder : Game -> Encode.Value
gameEncoder game =
    Encode.object
        [ ( "teamA", (teamEncoder game.teamA) )
        , ( "teamB", (teamEncoder game.teamB) )
        ]

teamEncoder : TeamData -> Encode.Value
teamEncoder teamData =
    Encode.object
        [ ( "name", Encode.string teamData.name )
        , ( "score", Encode.int teamData.score )
        ]
