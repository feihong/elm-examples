module Main exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation
import Util


main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Model =
    { history : List Navigation.Location
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( Model [ location ]
    , Cmd.none
    )



-- UPDATE


type Msg
    = UrlChange Navigation.Location



{- We are just storing the location in our history in this example, but
   normally, you would use a package like evancz/url-parser to parse the path
   or hash into nicely structured Elm values.

       <http://package.elm-lang.org/packages/evancz/url-parser/latest>

-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                _ =
                    Debug.log "url change" location
            in
                { model | history = location :: model.history } ! []



-- VIEW


view : Model -> Html msg
view model =
    div
        [ style
            [ ( "margin", "2rem" ) ]
        ]
        [ Util.bootstrap
        , div [ class "row" ]
            [ sidebar model
            , mainView (getHash model)
            ]
        ]


sidebar model =
    div [ class "col-sm-4" ]
        [ h2 [] [ text "Pages" ]
        , ul [] (List.map viewLink [ "bears", "cats", "dogs", "elephants", "fish" ])
        , h2 [] [ text "History" ]
        , ul [] (List.map viewLocation model.history)
        ]


mainView hash =
    div [ class "col-sm-8" ] [ text "hash" ]


viewLink : String -> Html msg
viewLink name =
    li [] [ a [ href ("#" ++ name) ] [ text name ] ]


viewLocation : Navigation.Location -> Html msg
viewLocation location =
    li [] [ text (location.pathname ++ location.hash) ]


getHash : Model -> String
getHash model =
    List.head model.history
        |> Maybe.map (\location -> location.hash)
        |> Maybe.withDefault ""
