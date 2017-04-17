module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Form exposing (Form)
import Form.Validate as Validate exposing (..)
import Form.Input as Input


-- your expected form output


type alias User =
    { email : String
    , emailConfirmed : Bool
    }



-- Add form to your model and msgs


type alias Model =
    { form : Form () User }


type Msg
    = NoOp
    | FormMsg Form.Msg



-- Setup form validation


init : ( Model, Cmd Msg )
init =
    ( { form = Form.initial [] validation }, Cmd.none )


validation : Validation () User
validation =
    map2 User
        (field "email" email)
        (field "emailConfirmed" bool)



-- Forward form msgs to Form.update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ form } as model) =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FormMsg formMsg ->
            ( { model | form = Form.update validation formMsg form }, Cmd.none )



-- Render form with Input helpers


view : Model -> Html Msg
view { form } =
    Html.map FormMsg (formView form)


formView : Form () User -> Html Form.Msg
formView form =
    let
        -- error presenter
        errorFor field =
            case field.liveError of
                Just error ->
                    -- replace toString with your own translations
                    div [ class "error" ] [ text (toString error) ]

                Nothing ->
                    text ""

        -- fields states
        email =
            Form.getFieldAsString "email" form

        emailConfirmed =
            Form.getFieldAsBool "emailConfirmed" form
    in
        div []
            [ div []
                [ label [] [ text "Email" ]
                , Input.textInput email []
                , errorFor email
                ]
            , div []
                [ label []
                    [ Input.checkboxInput emailConfirmed []
                    , text "Email confirmed"
                    ]
                ]
            , errorFor emailConfirmed
            , button
                [ onClick Form.Submit ]
                [ text "Submit" ]
            ]


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
