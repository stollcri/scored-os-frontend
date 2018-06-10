module Main exposing (..)

import Html exposing (Html, Attribute, button, div, input, text)
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
        [ input [ type_ "text", placeholder "Team A", onInput Name ] []
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.score) ]
        , button [ onClick Increment ] [ text "+" ]
        ]
    