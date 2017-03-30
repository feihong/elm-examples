port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, size, autofocus)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Json


-- Port for sendings strings to JS.


port speak : String -> Cmd msg



-- Port for getting speech statuses (as strings) from JS.


port speechStatus : (String -> msg) -> Sub msg


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Voice =
    { lang : String
    , name : String
    }


type alias Flags =
    { isSupported : Bool
    , initialText : String
    , voices : List Voice
    }


type SpeechStatus
    = None
    | Started
    | Ended


type alias Model =
    { isSupported : Bool
    , text : String
    , status : SpeechStatus
    , voices : List Voice
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { isSupported = flags.isSupported
      , text = flags.initialText
      , voices = (Debug.log "voices" flags.voices)
      , status = None
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Speak
    | ChangeText String
    | UpdateStatus String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Speak ->
            ( model, speak model.text )

        ChangeText text ->
            ( { model | text = text }, Cmd.none )

        UpdateStatus text ->
            let
                status =
                    case text of
                        "start" ->
                            Started

                        "end" ->
                            Ended

                        _ ->
                            None
            in
                ( { model | status = status }, Cmd.none )


onKeyEnter : a -> Html.Attribute a
onKeyEnter msg =
    let
        checkEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not enter key"
    in
        on "keypress" (Json.andThen checkEnter keyCode)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    speechStatus UpdateStatus



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ supportView model
        , div []
            [ input
                [ value model.text
                , onInput ChangeText
                , onKeyEnter Speak
                , size 50
                , autofocus True
                ]
                []
            , button [ onClick Speak ] [ text "Speak" ]
            ]
        , statusView model
        ]


supportView : Model -> Html Msg
supportView model =
    let
        ( tag, answer ) =
            if model.isSupported then
                ( em, "Yes" )
            else
                ( strong, "No" )
    in
        p []
            [ text "Is speech synthesis supported? "
            , tag
                []
                [ text answer ]
            ]


statusView : Model -> Html Msg
statusView model =
    let
        status =
            case model.status of
                Started ->
                    "Speech started"

                Ended ->
                    "Speech ended"

                None ->
                    ""
    in
        p [] [ text status ]
