module Messages exposing (..)

import Models exposing (Auth, Game, Games, Team)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = OnLocationChange Location
    | Login
    | Logout
    | UpdateAuth Auth
    | OnFindGame (WebData Games)
    | Name Team String
    | Score Team Int
    | Broadcast
    | OnGameUpdate (WebData Game)
    | Channel String
    | TuneIn
    | OnRemoteGameUpdate (WebData Game)
