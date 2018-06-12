module Main exposing (..)

import Html exposing (Html, Attribute, button, div, form, fieldset, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main = 
    Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
    { team: String
    , score: Int
    }

model : Model
model =
    { team = "Team A"
    , score = 0
    }


-- UPDATE

type Msg
    = Name String
    | Increment
    | Decrement

update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | team = name }

        Increment ->
            { model | score = model.score + 1 }

        Decrement ->
            { model | score = model.score - 1 }


-- VIEW

view : Model -> Html Msg
view model =
    div []
    [ scorebox model
    ]

scorebox : Model -> Html Msg
scorebox model =
    div []
    [ input [ type_ "text", onInput Name, placeholder "Team A", class "form-control" ] []
    , div [ class "input-group" ]
        [ div [ class "input-group-prepend" ]
            [ button [ onClick Decrement, class "btn btn-outline-secondary" ]
                [ span [ class "glyphicon glyphicon-minus" ] [ text "-" ]
                ]
            ]
        , input [ type_ "text", value (toString model.score), class "form-control" ] []
        , div [ class "input-group-prepend" ]
            [ button [ onClick Increment, class "btn btn-outline-secondary" ]
                [ span [ class "glyphicon glyphicon-plus" ] [ text "+" ]
                ]
            ]
        ]
    ]