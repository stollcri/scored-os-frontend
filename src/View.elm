module View exposing (..)

import Html exposing (Html, Attribute, a, br, button, div, input, span, text)
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

broadcastView: Game -> Html Msg
broadcastView game =
    div []
        [ scorebox TeamA game.teamA
        , scorebox TeamB game.teamB
        , div []
            [ br [] []
            , a [ href "#games/1" ] [ text "games/1" ]
            , br [] []
            , a [ href "#games/2" ] [ text "games/2" ]
            ]
        ]

scorebox : Team -> TeamData -> Html Msg
scorebox team teamData =
    div []
        [ input
            [ type_ "text"
            , value teamData.name
            , onInput (Name team)
            , placeholder "Add team name"
            , class "form-control"
            ] []
        , div [ class "input-group" ]
            [ div [ class "input-group-prepend" ]
                [ button [ onClick (Score team -1), class "btn btn-outline-secondary" ]
                    [ span [ class "glyphicon glyphicon-minus" ] [ text "-" ]
                    ]
                ]
            , input [ type_ "text", value (toString teamData.score), class "form-control" ] []
            , div [ class "input-group-prepend" ]
                [ button [ onClick (Score team 1), class "btn btn-outline-secondary" ]
                    [ span [ class "glyphicon glyphicon-plus" ] [ text "+" ]
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
                [ text "ok"
                ]

        RemoteData.Failure err ->
            text (toString err)

notFoundView : Html Msg
notFoundView = 
    div []
        [ text "404"
        ]
