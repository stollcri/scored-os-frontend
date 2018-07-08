module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import UrlParser exposing (..)
-- COMMANDS
import Http
import RemoteData
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)


init : Location -> ( Model, Cmd Msg )
init location =
    let currentRoute = parseLocation location
    in ( model currentRoute, fetchPlayers )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main = 
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- COMMANDS

fetchPlayers : Cmd Msg
fetchPlayers =
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


-- MODEL

type Route
    = BroadcastRoute
    | TuneInRoute String
    | NotFoundRoute

type Team
    = TeamA
    | TeamB

type alias TeamData =
    { name: String
    , score: Int
    }

type alias Game =
    { teamA: TeamData
    , teamB: TeamData
    }

type alias Model =
    { route: Route
    , game: Game
    , gameData: WebData Game
    }

model : Route -> Model
model route =
    { route = route
    , game =
        { teamA = { name = "Team A", score = 0 }
        , teamB = { name = "Team B", score = 0 }
        }
    , gameData = RemoteData.NotAsked
    }


-- ROUTING

matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ UrlParser.map BroadcastRoute top
        , UrlParser.map TuneInRoute (UrlParser.s "games" </> string)
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


-- UPDATE

type Msg
    = Name Team String
    | Score Team Int
    | OnLocationChange Location
    | OnFetchGame (WebData Game)

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


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ page model ]

page : Model -> Html Msg
page model  =
    case model.route of
        BroadcastRoute ->
            broadcastView model.game

        TuneInRoute id ->
            tuneInView model id

        NotFoundRoute ->
            notFoundView

broadcastView: Game -> Html Msg
broadcastView game =
    div []
        [ scorebox TeamA game.teamA
        , scorebox TeamB game.teamB
        , div []
            [ br [] []
            , a [ href "#games/1" ] [ text "games/1" ]
            , br [] []
            , a [ href "#games/2" ] [ text "games/2" ]
            ]
        ]

scorebox : Team -> TeamData -> Html Msg
scorebox team teamData =
    div []
        [ input
            [ type_ "text"
            , value teamData.name
            , onInput (Name team)
            , placeholder "Add team name"
            , class "form-control"
            ] []
        , div [ class "input-group" ]
            [ div [ class "input-group-prepend" ]
                [ button [ onClick (Score team -1), class "btn btn-outline-secondary" ]
                    [ span [ class "glyphicon glyphicon-minus" ] [ text "-" ]
                    ]
                ]
            , input [ type_ "text", value (toString teamData.score), class "form-control" ] []
            , div [ class "input-group-prepend" ]
                [ button [ onClick (Score team 1), class "btn btn-outline-secondary" ]
                    [ span [ class "glyphicon glyphicon-plus" ] [ text "+" ]
                    ]
                ]
            ]
        ]

tuneInView : Model -> String -> Html Msg
tuneInView model id =
    case model.gameData of
        RemoteData.NotAsked ->
            text "?"

        RemoteData.Loading ->
            text "Loading ..."

        RemoteData.Success game ->
            div []
                [ text "ok"
                ]

        RemoteData.Failure err ->
            text (toString err)

notFoundView : Html Msg
notFoundView = 
    div []
        [ text "404"
        ]
