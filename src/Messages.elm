module Messages exposing (..)

import Models exposing (Auth, Game, Team)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = Login
    | Logout
    | UpdateAuth Auth
    | Name Team String
    | Score Team Int
    | Channel String
    | TuneIn
    | OnLocationChange Location
    | OnFetchGame (WebData Game)
