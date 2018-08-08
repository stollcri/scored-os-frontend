module Commands exposing (findGame, getGame, saveGame, decodeSocketUpdate)

import Http
import RemoteData
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode

import Messages exposing (..)
import Models exposing (..)
import RemoteData exposing (WebData)


findGame : Config -> Auth -> Game -> Cmd Msg
findGame config auth game =
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
                , url = (findGameUrl config game.id)
                , body = Http.emptyBody
                , expect = Http.expectJson gamesDecoder
                , timeout = Nothing
                , withCredentials = False
                }
                |> RemoteData.sendRequest
                |> Cmd.map OnFindGame

getGame : Config -> String -> Cmd Msg
getGame config gameId =
    case gameId of
        "" ->
            Cmd.none

        gameId ->
            Http.get (getGameUrl config gameId) gameDecoder
                |> RemoteData.sendRequest
                |> Cmd.map OnRemoteGameUpdate

saveGame : Config -> Auth -> Game -> Cmd Msg
saveGame config auth game =
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
                    , url = (getGameUrl config game.id)
                    , body = Http.jsonBody (gameEncoder game)
                    , expect = Http.expectJson gameDecoder
                    , timeout = Nothing
                    , withCredentials = False
                    }
                    |> RemoteData.sendRequest
                    |> Cmd.map OnGameUpdate

decodeSocketUpdate : String -> Maybe (WebData Game)
decodeSocketUpdate socketUpdate =
    case Decode.decodeString gameUpdateDecoder socketUpdate of
        Ok decodedGameData ->
            case List.head (List.reverse decodedGameData.data) of
                Just (UpdateData game) ->
                    Just (RemoteData.Success game)

                _ ->
                    Nothing

        _ ->
            Nothing

-- PRIVATE

findGameUrl : Config -> String -> String
findGameUrl config gameId =
    config.urlApiRest ++ "/broadcasts/?"

getGameUrl : Config -> String -> String
getGameUrl config gameId =
    config.urlApiRest ++ "/broadcasts/" ++ gameId

gamesDecoder : Decode.Decoder Games
gamesDecoder =
    decode Games
        |> required "limit" Decode.int
        |> required "skip" Decode.int
        |> required "total" Decode.int
        |> required "data" (Decode.list gameDecoder)

gameDecoder : Decode.Decoder Game
gameDecoder =
    decode Game
        |> required "_id" Decode.string
        |> required "gameType" gameTypeDecoder
        |> required "teamA" teamDecoder
        |> required "teamB" teamDecoder

gameTypeDecoder : Decode.Decoder GameType
gameTypeDecoder =
    Decode.string
        |> Decode.andThen (\str ->
           case str of
                "football" ->
                    Decode.succeed Models.Football
                somethingElse ->
                    Decode.succeed Models.Soccer
        )

teamDecoder : Decode.Decoder TeamData
teamDecoder =
    decode TeamData
        |> required "name" Decode.string
        |> required "score" Decode.int

gameUpdateDecoder : Decode.Decoder GameUpdate
gameUpdateDecoder =
    decode GameUpdate
        |> required "type" Decode.int
        |> required "data" (Decode.list gameUpdateDataDecoder)

gameUpdateDataDecoder : Decode.Decoder GameUpdateData
gameUpdateDataDecoder =
    Decode.oneOf
        [ gameUpdateDataStringDecoder
        , gameUpdateDataGameDecoder
        ]

gameUpdateDataStringDecoder : Decode.Decoder GameUpdateData
gameUpdateDataStringDecoder =
    Decode.string
        |> Decode.andThen (\str ->
            case str of
                "broadcasts patched" ->
                    Decode.succeed BroadcastsPatched

                _ ->
                    let
                        _ = Debug.log "gameUpdateDataStringDecoder" str
                    in
                        Decode.succeed BroadcastsPatched
        )

gameUpdateDataGameDecoder : Decode.Decoder GameUpdateData
gameUpdateDataGameDecoder =
    gameDecoder
        |> Decode.andThen (\game ->
            Decode.succeed (UpdateData game)
        )


gameEncoder : Game -> Encode.Value
gameEncoder game =
    Encode.object
        [ ( "gameType", (gameTypeEncoder game.gameType) )
        , ( "teamA", (teamEncoder game.teamA) )
        , ( "teamB", (teamEncoder game.teamB) )
        ]

gameTypeEncoder : GameType -> Encode.Value
gameTypeEncoder gameType =
    let
        gameTypeEncoded =
            case gameType of
                Models.Soccer ->
                    "soccer"

                Models.Football ->
                    "football"
    in
        Encode.string gameTypeEncoded

teamEncoder : TeamData -> Encode.Value
teamEncoder teamData =
    Encode.object
        [ ( "name", Encode.string teamData.name )
        , ( "score", Encode.int teamData.score )
        ]
