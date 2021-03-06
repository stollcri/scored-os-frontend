port module Update exposing (..)

import Navigation exposing (load)
import RemoteData

import Commands exposing (getGame,  saveGame, decodeSocketUpdate)
import Messages exposing (..)
import Models exposing (..)
import Routing exposing (parseLocation)


port login : String -> Cmd msg
port logout : String -> Cmd msg
port updateAuth : (Auth -> msg) -> Sub msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            updateLocation (parseLocation location) model

        Login ->
            ( model, login "" )

        Logout ->
            ( model, logout "" )

        UpdateAuth auth ->
            ( { model | auth = auth }, Cmd.none )

        OnFindGame gameData ->
            case gameData of
                RemoteData.Success games ->
                    let
                        foundGame = 
                            case List.head games.data of
                                Nothing ->
                                    model.game

                                Just val ->
                                    val
                    in
                        ( { model | game = foundGame }, Cmd.none )

                RemoteData.Failure err ->
                    let
                        _ = Debug.log "error in OnFindGame" err
                    in
                        ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Name team name ->
            ( { model | game = updateGame msg model.game }
            , (saveGame model.config model.auth model.game)
            )

        Score team score ->
            let
                updatedModel = { model | game = updateGame msg model.game }
            in
                ( updatedModel, (saveGame updatedModel.config updatedModel.auth updatedModel.game))

        Broadcast ->
            ( model, (saveGame model.config model.auth model.game) )

        OnGameUpdate gameData ->
            case gameData of
                RemoteData.Success game ->
                    let
                        modelGame = model.game
                        updatedGame = { modelGame | id = game.id }
                    in
                        ( { model | game = updatedGame }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Channel channel ->
            ( { model | channel = channel }, Cmd.none )

        TuneIn ->
            ( model, load ("#games/" ++ model.channel) )

        OnRemoteGameUpdate remoteGameData ->
            ( { model | remoteGame = remoteGameData }, Cmd.none )

        OnRemoteGameUpdateSocket rawRemoteGameData ->
            if String.contains "primus::ping::" rawRemoteGameData then
                ( model, Cmd.none )

            else
                case decodeSocketUpdate rawRemoteGameData of
                    Just remoteGameData ->
                        ( { model | remoteGame = remoteGameData }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )


updateLocation : Route -> Model -> ( Model, Cmd Msg )
updateLocation route model =
    case route of
        TuneInRoute gameId ->
            let newRoute = route
            in ( { model | route = newRoute }, (getGame model.config gameId) )

        EnterChannelRoute ->
            let newRoute = route
            in ( { model | route = newRoute }, Cmd.none )

        _ ->
            let newRoute = route
            in ( { model | route = newRoute }, Cmd.none )

updateGame : Msg -> Game -> Game
updateGame msg game =
    case msg of
        Name team name ->
            case team of
                TeamA ->
                    let teamA = game.teamA
                    in { game | teamA = { teamA | name = name } }
                TeamB ->
                    let teamB = game.teamB
                    in { game | teamB = { teamB | name = name } }

        Score team score ->
            case team of
                TeamA ->
                    let teamA = game.teamA
                    in { game | teamA = { teamA | score = updateScore teamA.score score } }
                TeamB ->
                    let teamB = game.teamB
                    in { game | teamB = { teamB | score = updateScore teamB.score score } }

        _ ->
            game

updateScore : Int -> Int -> Int
updateScore totalScore score =
    if totalScore + score >= 0 then
        totalScore + score
    else
        totalScore
