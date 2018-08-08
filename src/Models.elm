module Models exposing (..)

import RemoteData exposing (WebData)


type Route
    = BroadcastRoute
    | EnterChannelRoute
    | TuneInRoute String
    | NotFoundRoute

type GameType
    = Soccer
    | Football

type Team
    = TeamA
    | TeamB

type GameUpdateData
    = BroadcastsPatched
    | UpdateData Game


type alias Auth =
    { accessToken: String
    , idToken: String
    , expiresAt: String
    }

type alias TeamData =
    { name: String
    , score: Int
    }

type alias Game =
    { id: String
    , gameType: GameType
    , teamA: TeamData
    , teamB: TeamData
    }

type alias Games =
    { limit: Int
    , skip: Int
    , total: Int
    , data: List Game
    }

type alias GameUpdate =
    { updateType: Int
    , data: List GameUpdateData
    }

type alias Model =
    { app: String
    , version: String
    , route: Route
    , auth: Auth
    , game: Game
    , channel: String
    , remoteGame: WebData Game
    }


initialModel : Route -> Auth -> Model
initialModel route auth =
    { app = "scoredy"
    , version = "1.0.0"
    , route = route
    , auth = auth
    , game =
        { id = ""
        , gameType = Soccer
        , teamA = { name = "Team A", score = 0 }
        , teamB = { name = "Team B", score = 0 }
        }
    , channel = ""
    , remoteGame = RemoteData.NotAsked
    }
