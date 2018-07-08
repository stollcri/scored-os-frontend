module Messages exposing (..)

import Models exposing (Game, Team)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = Name Team String
    | Score Team Int
    | OnLocationChange Location
    | OnFetchGame (WebData Game)
