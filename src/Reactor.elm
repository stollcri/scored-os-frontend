module Reactor exposing (..)

import Navigation exposing (Location)
import Html

import Main exposing (..)
import Messages exposing (..)
import Models exposing (..)
import Update exposing (update)
import View exposing (view)


-- elm-reactor does not work directly when the main program requires flags
-- this file can be ran from elm-reactor because it injects the required flags
main : Program Never Model Msg
main = 
    Navigation.program OnLocationChange
        { init = init
            { accessToken = ""
            , idToken = ""
            , expiresAt = ""
            }
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
