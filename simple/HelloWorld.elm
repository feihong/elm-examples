module Main exposing (..)

import Html exposing (Html, div, p, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


defaultValue : String
defaultValue =
    "Hello World"


choices : List ( String, String )
choices =
    [ ( "English", defaultValue )
    , ( "German", "Hallo Welt" )
    , ( "Chinese", "你好世界" )
    , ( "Japanese", "こんにちは世界" )
    , ( "Esperanto", "Saluton mondo" )
    ]


type alias Model =
    { greeting : String
    , choices : List ( String, String )
    }


model : Model
model =
    { greeting = defaultValue
    , choices = choices
    }



-- UPDATE


type Msg
    = CurrentGreeting String


update : Msg -> Model -> Model
update (CurrentGreeting greeting) model =
    { model | greeting = greeting }



-- VIEW


view : Model -> Html Msg
view model =
    let
        languageButtons =
            List.map (languageButton model.greeting) model.choices
    in
        div []
            [ p [] [ text model.greeting ]
            , div [] languageButtons
            ]


languageButton : String -> ( String, String ) -> Html Msg
languageButton greeting ( language, value ) =
    let
        styles =
            if greeting == value then
                [ ( "font-weight", "bold" ) ]
            else
                []
    in
        button
            [ style <| ( "margin-right", "1rem" ) :: styles
            , onClick (CurrentGreeting value)
            ]
            [ text language ]
