module Views.Header exposing (show)

import Html exposing (Html, Attribute, a, div, h1, h2, nav, section, span, text)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaLabel, ariaHidden, ariaExpanded, role)

import Messages exposing (..)


show : Html Msg
show =
    div []
        [ section [ class "hero is-dark" ]
            [ div [ class "hero-body" ]
                [ div [ class "container" ]
                    [ h1 [ class "title" ]
                        [ text "Mark-a-Score" ]
                    , h2 [ class "subtitle" ]
                        [ text "Live, local, sports, scores" ]
                    ]
                ]
            ]
        , nav [ class "navbar", role "navigation", ariaLabel "main navigation" ]
            [ div [ class "navbar-brand" ]
                [ a [ class "navbar-item", href "#" ]
                    [ text "Broadcast"]
                , a [ class "navbar-item", href "#games" ]
                    [ text "Tune In"]
                , a [ class "navbar-item", href "#games/1" ]
                    [ text "Game 1"]
                , a [ class "navbar-item", href "#games/2" ]
                    [ text "Game 2"]
                ]
            ]
        ]