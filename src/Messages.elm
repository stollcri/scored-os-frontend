module Messages exposing (..)

import Models exposing (Auth, Game, Team)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = OnLocationChange Location
    | Login
    | Logout
    | UpdateAuth Auth
    | Name Team String
    | Score Team Int
    | Broadcast
    | OnGameUpdate (WebData Game)
    | Channel String
    | TuneIn
    | OnGameDataUpdate (WebData Game)
