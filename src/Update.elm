port module Update exposing (..)

import Navigation exposing (load)

import Commands exposing (fetchGame)
import Messages exposing (..)
import Models exposing (..)
import Routing exposing (parseLocation)
import Debug

port login : String -> Cmd msg
port logout : String -> Cmd msg
port updateAuth : (Auth -> msg) -> Sub msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            ( model, login "" )

        Logout ->
            ( model, logout "" )

        UpdateAuth auth ->
            ( { model | auth = auth }, Cmd.none )

        Name team name ->
            ( { model | game = updateGame msg model.game }, Cmd.none )

        Score team score ->
            ( { model | game = updateGame msg model.game }, Cmd.none )

        Channel channel ->
            ( { model | channel = channel }, Cmd.none )

        TuneIn ->
            ( model, load ("#games/" ++ model.channel) )

        OnLocationChange location ->
            updateLocation (parseLocation location) model

        OnFetchGame gameData ->
            ( { model | gameData = gameData }, Cmd.none )

updateLocation : Route -> Model -> ( Model, Cmd Msg )
updateLocation route model =
    case route of
        TuneInRoute gameId ->
            let newRoute = route
            in ( { model | route = newRoute }, (fetchGame gameId) )

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
