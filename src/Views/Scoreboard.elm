module Views.Scoreboard exposing (edit, show)

import Html exposing (Html, a, div, i, input, section, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

import Models exposing (..)
import Messages exposing (..)


edit : Team -> TeamData -> Team -> TeamData -> Html Msg
edit teamA teamAData teamB teamBData =
    section [ class "section" ]
        [ div [ class "container" ]
            [ scoreBox TeamA teamAData False
            , scoreBox TeamB teamBData False
            ]
        ]

show : Team -> TeamData -> Team -> TeamData -> Html Msg
show teamA teamAData teamB teamBData =
    section [ class "section" ]
        [ div [ class "container" ]
            [ scoreBox TeamA teamAData True
            , scoreBox TeamB teamBData True
            ]
        ]

-- PRIVATE

scoreBox : Team -> TeamData -> Bool -> Html Msg
scoreBox team teamData disabled =
    div [ class "columns" ]
        [ teamName team teamData
        , teamScore team teamData
        ]

teamName : Team -> TeamData -> Html Msg
teamName team teamData =
    div [ class "column" ]
        [ input
            [ type_ "text"
            , value teamData.name
            , onInput (Name team)
            , placeholder "Add team name"
            , class "input"
            ] []
        ]

teamScore : Team -> TeamData -> Html Msg
teamScore team teamData =
    div [ class "column" ]
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
