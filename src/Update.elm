module Update exposing (..)

import Messages exposing (..)
import Models exposing (..)
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Name team name ->
            ( { model | game = updateGame msg model.game }, Cmd.none )

        Score team score ->
            ( { model | game = updateGame msg model.game }, Cmd.none )

        OnLocationChange location ->
            let newRoute = parseLocation location
            in ( { model | route = newRoute }, Cmd.none )

        -- TODO: actually load game data
        OnFetchGame gameData ->
            let
                result = model
                _ = Debug.log "RESULT (update)" gameData
            in 
                ( result, Cmd.none )

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
