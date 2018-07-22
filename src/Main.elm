module Main exposing (..)

import Navigation exposing (Location)

import Commands exposing (fetchGame)
import Messages exposing (..)
import Models exposing (..)
import Routing exposing (..)
import Update exposing (update, updateAuth)
import View exposing (view)


init : Auth -> Location -> ( Model, Cmd Msg )
init auth location =
    let
        currentRoute = parseLocation location
        model = initialModel currentRoute auth
    in
        case currentRoute of
            TuneInRoute channel ->
                ( model, (fetchGame channel) )

            _ ->
                ( model, (fetchGame "") )

subscriptions : Model -> Sub Msg
subscriptions model =
    updateAuth UpdateAuth

-- Got this error?
--   Expecting an object with a field named ____ but instead got: undefined
-- When using elm-reactor do not run this program, run Reactor.elm
main : Program Auth Model Msg
main = 
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
