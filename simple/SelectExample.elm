{- Interestingly, the selected attribute is only needed for when the DOM
   first displays. As soon as model values start being updated, the value
   attribute will cause the correct option to be selected.
-}


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, on, keyCode)
import Json.Decode as Decode


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Model =
    { name : String
    , inputValue : String
    }


initModel =
    { name = "Coolio"
    , inputValue = ""
    }


choices =
    [ "Sophia", "Bolivar", "Logan", "Coolio", "Lion-O", "Starscream" ]



-- UPDATE


type Msg
    = NoOp
    | ChangeName String
    | ChangeNameViaInput
    | ChangeInputValue String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeName str ->
            let
                _ =
                    Debug.log "change name" str
            in
                { model | name = str } ! []

        ChangeNameViaInput ->
            { model | name = model.inputValue } ! []

        ChangeInputValue str ->
            { model | inputValue = str } ! []

        NoOp ->
            model ! []



-- VIEW


view : Model -> Html Msg
view model =
    let
        choicesPairs =
            ( "", "Select name" )
                :: ( "line", "-----" )
                :: (List.map (\name -> ( name, name )) choices)
    in
        div [ style [ ( "padding", "1rem" ) ] ]
            [ div []
                [ input
                    [ autofocus True
                    , value model.inputValue
                    , onInput ChangeInputValue
                    , onKeyEnter ChangeNameViaInput
                    ]
                    []
                ]
            , namesSelect model 1 choicesPairs
            , namesSelect model 8 choicesPairs
            ]


namesSelect model size_ choicesPairs =
    div []
        [ select
            [ size size_
            , value model.name
            , onInput ChangeName
            ]
            (List.map (nameOption model.name) choicesPairs)
        ]


nameOption current ( value_, title ) =
    option
        [ value value_
        , disabled <| value_ == "line"
        , selected <| value_ == current
        ]
        [ text title ]


onKeyEnter : msg -> Html.Attribute msg
onKeyEnter msg =
    let
        decoder =
            keyCode
                |> Decode.andThen
                    (\code ->
                        if code == 13 then
                            Decode.succeed msg
                        else
                            Decode.fail "not enter key"
                    )
    in
        on "keypress" decoder
