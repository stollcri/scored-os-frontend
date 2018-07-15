module View exposing (..)

import Html exposing (Html, Attribute, a, br, button, div, h1, h2, i, input, section, span, text)
import Html.Attributes exposing (..)
import RemoteData

import Models exposing (..)
import Messages exposing (..)
import Views.Header
import Views.Scoreboard
import Views.TuneIn


view : Model -> Html Msg
view model =
    page model

page : Model -> Html Msg
page model  =
    case model.route of
        BroadcastRoute ->
            broadcastView model.game

        EnterChannelRoute ->
            enterChannelView model.channel

        TuneInRoute id ->
            tuneInView model id

        NotFoundRoute ->
            notFoundView

broadcastView: Game -> Html Msg
broadcastView game =
    div []
        [ Views.Header.show
        , Views.Scoreboard.edit game
        ]

enterChannelView : String -> Html Msg
enterChannelView channel =
    div []
        [ Views.Header.show
        , Views.TuneIn.show channel
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
                , Views.Scoreboard.show game
                ]

        RemoteData.Failure err ->
            div []
                [ Views.Header.show
                , section [ class "section" ]
                    [ div [ class "notification is-warning" ]
                        [ text "Game has ended or is no longer being broadcast" ]
                    ]
                ]

notFoundView : Html Msg
notFoundView = 
    div []
        [ Views.Header.show
        , section [ class "section" ]
            [ text "Hmmm, I'm not sure what to do with that. Maybe try clicking one of the links in the menu" ]
        ]
