module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import Util


main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias Content =
    { slug : String
    , title : String
    , color : String
    , message : String
    }


defaultContent =
    Content "" "Navigation Example" "white" "This is the default page"


contents =
    [ Content "bears" "熊" "sandybrown" "熊喜欢吃鱼"
    , Content "cats" "猫" "coral" "猫会说喵喵"
    , Content "dogs" "狗" "tan" "狗会说汪汪"
    , Content "elephants" "象" "gainsboro" "象喜欢吃草"
    , Content "fish" "鱼" "paleturquoise" "鱼是沉默的"
    ]


getContent : String -> Content
getContent slug_ =
    contents
        |> List.filter (\{ slug } -> slug_ == "#" ++ slug)
        |> List.head
        |> Maybe.withDefault defaultContent



-- MODEL


type alias Model =
    { history : List Navigation.Location
    , hash : String
    }


{-| Note that init takes a location argument
-}
init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    Model [ location ] "" ! []



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
                    Debug.log "url change location" location
            in
                { model
                    | history = location :: model.history
                    , hash = location.hash
                }
                    ! []



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
            , mainView (getContent model.hash)
            ]
        ]


sidebar model =
    div [ class "col-sm-4" ]
        [ h2 [] [ text "Pages" ]
        , ul [] (List.map viewLink contents)
        , h2 [] [ text "History" ]
        , ul [] (List.map viewLocation model.history)
        ]


mainView { title, color, message } =
    div [ class "col-sm-8", style [ ( "backgroundColor", color ) ] ]
        [ h1 [] [ text title ]
        , p [] [ text message ]
        ]


viewLink : Content -> Html msg
viewLink { slug, title } =
    li []
        [ a [ href ("#" ++ slug) ]
            [ text title ]
        ]


viewLocation : Navigation.Location -> Html msg
viewLocation location =
    li [] [ text (location.pathname ++ location.hash) ]
