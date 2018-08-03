module Commands exposing (findGame, getGame, saveGame)

import Http
import RemoteData
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode

import Messages exposing (..)
import Models exposing (Auth, Game, TeamData)


findGame : Game -> Auth -> Cmd Msg
findGame game auth =
    case auth.accessToken of
        "" ->
            Cmd.none

        _ ->
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Accept" "application/json"
                    , Http.header "Authorization" ("Bearer " ++ auth.accessToken)
                    ]
                , url = (findGameUrl game.id)
                , body = Http.emptyBody
                , expect = Http.expectJson gameDecoder
                , timeout = Nothing
                , withCredentials = False
                }
                |> RemoteData.sendRequest
                |> Cmd.map OnGameUpdate

getGame : String -> Cmd Msg
getGame gameId =
    case gameId of
        "" ->
            Cmd.none

        gameId ->
            Http.get (getGameUrl gameId) gameDecoder
                |> RemoteData.sendRequest
                |> Cmd.map OnRemoteGameUpdate

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
                        , Http.header "Authorization" ("Bearer " ++ auth.accessToken)
                        ]
                    , url = (getGameUrl game.id)
                    , body = Http.jsonBody (gameEncoder game)
                    , expect = Http.expectJson gameDecoder
                    , timeout = Nothing
                    , withCredentials = False
                    }
                    |> RemoteData.sendRequest
                    |> Cmd.map OnGameUpdate

-- PRIVATE

findGameUrl : String -> String
findGameUrl gameId =
    "http://localhost:3030/broadcasts/?"

getGameUrl : String -> String
getGameUrl gameId =
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
