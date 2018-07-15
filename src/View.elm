module View exposing (..)

import Html exposing (Html, Attribute, a, br, button, div, h1, h2, i, input, section, span, text)
import Html.Attributes exposing (..)
import RemoteData

import Models exposing (..)
import Messages exposing (..)
import Views.Header
import Views.Scoreboard


view : Model -> Html Msg
view model =
    page model

page : Model -> Html Msg
page model  =
    case model.route of
        BroadcastRoute ->
            broadcastView model.game

        EnterChannelRoute ->
            enterChannelView

        TuneInRoute id ->
            tuneInView model id

        NotFoundRoute ->
            notFoundView

broadcastView: Game -> Html Msg
broadcastView game =
    div []
        [ Views.Header.show
        , Views.Scoreboard.edit TeamA game.teamA TeamB game.teamB
        ]

enterChannelView : Html Msg
enterChannelView =
    div []
        [ Views.Header.show
        , section [ class "section" ]
            [ text "Enter game id:" ]
        ]

tuneInView : Model -> String -> Html Msg
tuneInView model id =
    case model.gameData of
        RemoteData.NotAsked ->
            div []
                [ Views.Header.show
                , section [ class "section" ]
                    [ text "Data not loaded" ]
                ]

        RemoteData.Loading ->
            div []
                [ Views.Header.show
                , section [ class "section" ]
                    [ text "Loading ..." ]
                ]

        RemoteData.Success game ->
            div []
                [ Views.Header.show
                , Views.Scoreboard.show TeamA game.teamA TeamB game.teamB
                ]

        RemoteData.Failure err ->
            text (toString err)

notFoundView : Html Msg
notFoundView = 
    div []
        [ Views.Header.show
        , section [ class "section" ]
            [ text "Hmmm, I'm not sure what to do with that. Maybe if you click some link you'll find what you're looking for" ]
        ]
