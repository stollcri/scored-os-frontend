module Models exposing (..)

import RemoteData exposing (WebData)


type Route
    = BroadcastRoute
    | EnterChannelRoute
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
    , channel: String
    , gameData: WebData Game
    }


model : Route -> Model
model route =
    { route = route
    , game =
        { teamA = { name = "Team A", score = 0 }
        , teamB = { name = "Team B", score = 0 }
        }
    , channel = ""
    , gameData = RemoteData.NotAsked
    }
