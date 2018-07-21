module Main exposing (..)

import Navigation exposing (Location)

import Commands exposing (fetchGame)
import Messages exposing (..)
import Models exposing (..)
import Routing exposing (..)
import Update exposing (update)
import View exposing (view)


init : Location -> ( Model, Cmd Msg )
init location =
    let currentRoute = parseLocation location
    in
        case currentRoute of
            TuneInRoute channel ->
                ( initialModel currentRoute, (fetchGame channel) )

            _ ->
                ( initialModel currentRoute, (fetchGame "") )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never Model Msg
main = 
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
