module Views.TuneIn exposing (show)

import Html exposing (Html, a, div, input, section, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

import Messages exposing (..)


show : String -> Html Msg
show channel =
    section [ class "section" ]
        [ div [ class "container" ]
            [ channelBox channel
            ]
        ]

-- PRIVATE

channelBox : String -> Html Msg
channelBox channel =
    div [ class "field has-addons" ]
        [ div [ class "control is-expanded" ]
            [ input
                [ type_ "text"
                , placeholder "Channel"
                , value channel
                , onInput Channel
                , class "input"
                ] []
            ]
        , div [ class "control" ]
            [ a [ onClick (TuneIn), class "button is-primary" ]
                [ text "GO!" ]
            ]
        ]
