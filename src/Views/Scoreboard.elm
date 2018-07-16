module Views.Scoreboard exposing (edit, show)

import Html exposing (Html, button, div, i, input, section, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

import Models exposing (..)
import Messages exposing (..)


edit : Game -> Html Msg
edit game =
    section [ class "section" ]
        [ div [ class "container" ]
            [ scoreBox TeamA game.teamA False
            , scoreBox TeamB game.teamB False
            , div [ class "has-text-centered" ]
                [ button [ class "button is-primary" ]
                    [ text "Broadcast" ]
                ]
            ]
        ]

show : Game -> Html Msg
show game =
    section [ class "section" ]
        [ div [ class "container" ]
            [ scoreBox TeamA game.teamA True
            , scoreBox TeamB game.teamB True
            ]
        ]

-- PRIVATE

scoreBox : Team -> TeamData -> Bool -> Html Msg
scoreBox team teamData isDisabled =
    div [ class "columns" ]
        [ teamName team teamData isDisabled
        , teamScore team teamData isDisabled
        ]

teamName : Team -> TeamData -> Bool -> Html Msg
teamName team teamData isDisabled =
    div [ class "column" ]
        [ input
            [ class "input"
            , disabled isDisabled
            , onInput (Name team)
            , placeholder "Add team name"
            , type_ "text"
            , value teamData.name
            ] []
        ]

teamScore : Team -> TeamData -> Bool -> Html Msg
teamScore team teamData isDisabled =
    div [ class "column" ]
        [ div [ class "field has-addons" ]
            [ div [ class "control" ]
                [ button
                    [ class "button is-primary"
                    , disabled isDisabled
                    , onClick (Score team -1)
                    ]
                    [ i [ class "fas fa-minus-circle" ] []
                    ]
                ]
            , div [ class "control is-expanded" ]
                [ input
                    [ class "input"
                    , disabled isDisabled
                    , type_ "text"
                    , value (toString teamData.score)
                    ] []
                ]
            , div [ class "control" ]
                [ button
                    [ class "button is-primary"
                    , disabled isDisabled
                    , onClick (Score team 1)
                    ]
                    [ i [ class "fas fa-plus-circle" ] []
                    ]
                ]
            ]
        ]
