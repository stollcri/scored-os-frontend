module Main exposing (..)

import Navigation exposing (Location)

import Commands exposing (findGame, getGame)
import Messages exposing (..)
import Models exposing (..)
import Platform.Sub exposing ( Sub )
import RemoteData
import Routing exposing (..)
import Update exposing (update, updateAuth)
import View exposing (view)
import WebSocket


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute = parseLocation location
        model = initialModel flags currentRoute
    in
        case currentRoute of
            BroadcastRoute ->
                ( model, (findGame model.config model.auth model.game) )

            TuneInRoute channel ->
                ( model, (getGame model.config channel) )

            _ ->
                ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
    let
        currentRemoteGameId =
            case model.remoteGame of
                RemoteData.Success game ->
                    game.id

                _ ->
                    ""
    in
        case currentRemoteGameId of
            "" ->
                updateAuth UpdateAuth

            _ ->
                Sub.batch
                    [ updateAuth UpdateAuth
                    , WebSocket.listen
                        model.config.urlApiWebsocket
                        OnRemoteGameUpdateSocket
                    ]

-- Got this error?
--   Expecting an object with a field named ____ but instead got: undefined
-- When using elm-reactor do not run this program, run Reactor.elm
main : Program Flags Model Msg
main = 
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
