port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, size, autofocus)
import Html.Events exposing (onClick, onInput, on, keyCode, targetValue)
import Json.Decode as Json


{-| Port for sendings phrases and lang codes to JS.
-}
port speak : ( String, String ) -> Cmd msg


{-| Port for getting speech statuses (as strings) from JS.
-}
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
    , initialPhrase : String
    , voices : List Voice
    }


type SpeechStatus
    = None
    | Started
    | Ended


type alias Model =
    { isSupported : Bool
    , phrase : String
    , status : SpeechStatus
    , voices : List Voice
    , currentLang : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { isSupported = flags.isSupported
      , phrase = flags.initialPhrase
      , voices = flags.voices
      , status = None
      , currentLang = "en-US"
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Speak
    | ChangePhrase String
    | UpdateStatus String
    | SelectVoice String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Speak ->
            model ! [ speak ( model.phrase, model.currentLang ) ]

        ChangePhrase phrase ->
            { model | phrase = phrase } ! []

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
                { model | status = status } ! []

        SelectVoice lang ->
            { model | currentLang = lang } ! []


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
                [ value model.phrase
                , onInput ChangePhrase
                , onKeyEnter Speak
                , size 50
                , autofocus True
                ]
                []
            , select [ onChange SelectVoice ] (options model.voices)
            , button [ onClick Speak ] [ text "Speak" ]
            ]
        , statusView model
        ]


onChange : (String -> value) -> Attribute value
onChange msg =
    on "change" (Json.map msg targetValue)


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


statusView : Model -> Html msg
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


options : List Voice -> List (Html msg)
options voices =
    let
        voiceOption voice =
            option [ value voice.lang ]
                [ text <| voice.name ++ " (" ++ voice.lang ++ ")" ]
    in
        voices
            |> List.map voiceOption
