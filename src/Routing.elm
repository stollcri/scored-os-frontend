module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (Route(..))
import UrlParser exposing (..)


-- TODO: add game id entry route
--   map BroadcastRoute (s "games")
--   -- becomes --
--   map FindGameRoute (s "games")
matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map BroadcastRoute top
        , map EnterChannelRoute (s "games")
        , map TuneInRoute (s "games" </> string)
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
