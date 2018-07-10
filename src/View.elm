module View exposing (..)

import Html exposing (Html, Attribute, a, br, button, div, h1, h2, i, input, section, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Models exposing (..)
import Messages exposing (..)


view : Model -> Html Msg
view model =
    page model

page : Model -> Html Msg
page model  =
    case model.route of
        BroadcastRoute ->
            broadcastView model.game

        TuneInRoute id ->
            tuneInView model id

        NotFoundRoute ->
            notFoundView

viewheader : Html Msg
viewheader =
    section [ class "hero is-dark" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "Mark-a-Score" ]
                , h2 [ class "subtitle" ]
                    [ text "Live, local, sports, scores" ]
                ]
            ]
        ]

broadcastView: Game -> Html Msg
broadcastView game =
    div []
        [ viewheader
        , section [ class "section" ]
            [ div [ class "container" ]
                [ scoreboard TeamA game.teamA
                , scoreboard TeamB game.teamB
                , div [ class "columns" ]
                    [ div [ class "column" ]
                        [ a [ href "#games/1" ] [ text "games/1" ] ]
                    , div [ class "column" ]
                        [ a [ href "#games/2" ] [ text "games/2" ] ]
                    ]
                ]
            ]
        ]

tuneInView : Model -> String -> Html Msg
tuneInView model id =
    case model.gameData of
        RemoteData.NotAsked ->
            text "?"

        RemoteData.Loading ->
            text "Loading ..."

        RemoteData.Success game ->
            div []
                [ viewheader
                , section [ class "section" ]
                    [ div [ class "container" ]
                        [ scoreboard TeamA game.teamA
                        , scoreboard TeamB game.teamB
                        ]
                    ]
                ]

        RemoteData.Failure err ->
            text (toString err)

scoreboard : Team -> TeamData -> Html Msg
scoreboard team teamData =
    div [ class "columns" ]
        [ div [ class "column" ]
            [ input
                [ type_ "text"
                , value teamData.name
                , onInput (Name team)
                , placeholder "Add team name"
                , class "input"
                ] []
            ]
        , div [ class "column" ]
            [ div [ class "field has-addons" ]
                [ div [ class "control" ]
                    [ a [ onClick (Score team -1), class "button is-primary" ]
                        [ i [ class "fas fa-minus-circle" ] []
                        ]
                    ]
                , div [ class "control is-expanded" ]
                    [ input
                        [ type_ "text"
                        , value (toString teamData.score)
                        , class "input"
                        ] []
                    ]
                , div [ class "control" ]
                    [ a [ onClick (Score team 1), class "button is-primary" ]
                        [ i [ class "fas fa-plus-circle" ] []
                        ]
                    ]
                ]
            ]
        ]

notFoundView : Html Msg
notFoundView = 
    div []
        [ text "404"
        ]
