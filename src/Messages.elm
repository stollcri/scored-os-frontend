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
    | OnSaveGame (WebData Game)
    | Channel String
    | TuneIn
    | OnFetchGame (WebData Game)