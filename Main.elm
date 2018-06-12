module Main exposing (..)

import Html exposing (Html, Attribute, button, div, form, fieldset, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main = 
    Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Team =
    { name: String
    , score: Int
    }

type alias Model =
    { teams: List Team
    }

model : Model
model =
    { teams =
        [ { name = "Team A", score = 0 }
        , { name = "Team B", score = 0 }
        ]
    }


-- UPDATE

type Msg
    = Name Team String
    | Increment Team
    | Decrement Team

update : Msg -> Model -> Model
update msg model =
    case msg of
        Name team name->
            let
                updateTeam t =
                    if t == team then
                        { t | name = name }
                    else
                        t

                updatedTeams =
                    List.map updateTeam model.teams
            in
                { model | teams = updatedTeams }

        Increment team ->
            let
                updateTeam t =
                    if t == team then
                        { t | score = team.score + 1 }
                    else
                        t

                updatedTeams =
                    List.map updateTeam model.teams
            in
                { model | teams = updatedTeams }

        Decrement team ->
            let
                updateTeam t =
                    if t == team then
                        { t | score = team.score - 1 }
                    else
                        t

                updatedTeams =
                    List.map updateTeam model.teams
            in
                { model | teams = updatedTeams }

-- VIEW

view : Model -> Html Msg
view model =
    div []
    (List.map scorebox model.teams)

scorebox : Team -> Html Msg
scorebox team =
    div []
    [ input [ type_ "text", value team.name, onInput (Name team), placeholder "Add team name", class "form-control" ] []
    , div [ class "input-group" ]
        [ div [ class "input-group-prepend" ]
            [ button [ onClick (Decrement team), class "btn btn-outline-secondary" ]
                [ span [ class "glyphicon glyphicon-minus" ] [ text "-" ]
                ]
            ]
        , input [ type_ "text", value (toString team.score), class "form-control" ] []
        , div [ class "input-group-prepend" ]
            [ button [ onClick (Increment team), class "btn btn-outline-secondary" ]
                [ span [ class "glyphicon glyphicon-plus" ] [ text "+" ]
                ]
            ]
        ]
    ]
