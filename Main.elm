module Main exposing (..)

import Html exposing (Html, Attribute, button, div, form, fieldset, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main = 
    Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type Team
    = TeamA
    | TeamB

type alias TeamData =
    { name: String
    , score: Int
    }

type alias Model =
    { teamA: TeamData
    , teamB: TeamData
    }

model : Model
model =
    { teamA = { name = "Team A", score = 0 }
    , teamB = { name = "Team B", score = 0 }
    }


-- UPDATE

type Msg
    = Name Team String
    | Score Team Int

update : Msg -> Model -> Model
update msg model =
    case msg of
        Name team name ->
            case team of
                TeamA ->
                    let teamA = model.teamA
                    in { model | teamA = { teamA | name = name } }
                TeamB ->
                    let teamB = model.teamB
                    in { model | teamB = { teamB | name = name } }

        Score team score ->
            case team of
                TeamA ->
                    let teamA = model.teamA
                    in { model | teamA = { teamA | score = updateScore teamA.score score } }
                TeamB ->
                    let teamB = model.teamB
                    in { model | teamB = { teamB | score = updateScore teamB.score score } }

updateScore : Int -> Int -> Int
updateScore totalScore score =
    if totalScore + score >= 0 then
        totalScore + score

    else
        totalScore

-- VIEW

view : Model -> Html Msg
view model =
    div []
    [ scorebox TeamA model.teamA
    , scorebox TeamB model.teamB
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
