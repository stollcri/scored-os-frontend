module View exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Html exposing (Html, Attribute, a, br, button, div, h1, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Models exposing (..)
import Messages exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ page model ]

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
    Grid.row []
        [ Grid.col []
            [ h1 []
                [ text "Mark-a-Score"
                ]
            ]
        ]

broadcastView: Game -> Html Msg
broadcastView game =
    Grid.container []
        [ viewheader
        , scoreboard TeamA game.teamA
        , scoreboard TeamB game.teamB
        , Grid.row []
            [ Grid.col []
                [ Form.form []
                    [ a [ href "#games/1" ] [ text "games/1" ]
                    ]
                ]
            ]
        , Grid.row []
            [ Grid.col []
                [ a [ href "#games/2" ] [ text "games/2" ] ]
            ]
        ]

scoreboard : Team -> TeamData -> Html Msg
scoreboard team teamData =
    Grid.row []
        [ Grid.col []
            [ Form.group []
                [ Input.text
                    [ Input.attrs
                        [ placeholder "Add team name"
                        , value teamData.name
                        , onInput (Name team)
                        ]
                    ]
                , InputGroup.config
                    ( InputGroup.text
                        [ Input.attrs [ value (toString teamData.score) ]
                        ]
                    )
                    |> InputGroup.predecessors
                        [ InputGroup.button
                            [ Button.danger
                            , Button.attrs [ onClick (Score team -1) ]
                            ]
                            [ text "-"]
                        ]
                    |> InputGroup.successors
                        [ InputGroup.button
                            [ Button.success
                            , Button.attrs [ onClick (Score team 1) ]
                            ]
                            [ text "+"]
                        ]
                    |> InputGroup.view
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
            Grid.container []
                [ viewheader
                , scorebox TeamA game.teamA
                , scorebox TeamB game.teamB
                ]

        RemoteData.Failure err ->
            text (toString err)

scorebox : Team -> TeamData -> Html Msg
scorebox team teamData =
    Grid.row []
        [ Grid.col []
            [ Form.group []
                [ Input.text
                    [ Input.attrs
                        [ value teamData.name
                        , disabled True
                        ]
                    ]
                , InputGroup.config
                    ( InputGroup.text
                        [ Input.attrs
                            [ value (toString teamData.score)
                            , disabled True
                            ]
                        ]
                    )
                    |> InputGroup.predecessors
                        [ InputGroup.button
                            [ Button.danger
                            , Button.attrs [ disabled True ]
                            ]
                            [ text "-"]
                        ]
                    |> InputGroup.successors
                        [ InputGroup.button
                            [ Button.success
                            , Button.attrs [ disabled True ]
                            ]
                            [ text "+"]
                        ]
                    |> InputGroup.view
                ]
            ]
        ]

notFoundView : Html Msg
notFoundView = 
    div []
        [ text "404"
        ]
