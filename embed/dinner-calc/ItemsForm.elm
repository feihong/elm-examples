module ItemsForm exposing (..)

import Regex
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, on)
import Json.Decode as Decode
import Validate exposing (Validator, ifBlank, ifInvalid)
import ViewUtil


type alias Config msg =
    { addMsg : String -> String -> Int -> msg
    , updateMsg : Int -> String -> String -> Int -> msg
    , removeMsg : Int -> msg
    }


type alias State =
    { newItem : ItemForm
    , items : List ItemForm
    }


type alias ItemForm =
    { payer : String
    , name : String
    , amount : String
    , errors : List ( Field, String )
    }


type Msg
    = UpdateNewPayer String
    | UpdateNewName String
    | UpdateNewAmount String
    | AddItem
    | UpdatePayer Int String
    | UpdateName Int String
    | UpdateAmount Int String


type Field
    = Payer
    | Name
    | Amount


initialState =
    { newItem = ItemForm "Group" "" "" []
    , items = []
    }


update : Config msg -> Msg -> State -> ( State, Maybe msg )
update config msg state =
    case msg of
        UpdateNewPayer str ->
            state |> updateNewItem Payer str |> noMsg

        UpdateNewName str ->
            state |> updateNewItem Name str |> noMsg

        UpdateNewAmount str ->
            state |> updateNewItem Amount str |> noMsg

        AddItem ->
            let
                errors =
                    validateForm state.newItem

                maybeParentMsg =
                    if List.isEmpty errors then
                        Just <|
                            (getFormValues state.newItem
                                |> \( payer, name, amt ) -> config.addMsg payer name amt
                            )
                    else
                        Nothing

                newItem =
                    state.newItem

                newItem2 =
                    { newItem | errors = errors }
            in
                ( { state | newItem = newItem2 }, maybeParentMsg )

        _ ->
            ( state, Nothing )


validateForm : ItemForm -> List ( Field, String )
validateForm =
    Validate.all
        [ .name >> ifBlank ( Name, "Name cannot be blank" )
        , .amount >> ifBlank ( Amount, "Amount cannot be blank" )
        , .amount >> ifNotCurrency ( Amount, "Not a valid value for currency" )
        ]


getFormValues ({ payer, name, amount } as itemForm) =
    let
        amount_ =
            case Decode.decodeString Decode.float amount of
                Ok value ->
                    round <| value * 100

                Err _ ->
                    -1
    in
        ( payer, name, amount_ )


currencyRegex =
    Regex.regex "^[0-9]{1,3}(?:,?[0-9]{3})*(?:\\.[0-9]{2})?$"


ifNotCurrency : error -> Validator error String
ifNotCurrency =
    ifInvalid <| not << Regex.contains currencyRegex


updateNewItem field value state =
    let
        newItem =
            state.newItem

        newItem_ =
            case field of
                Payer ->
                    { newItem | payer = value }

                Name ->
                    { newItem | name = value }

                Amount ->
                    { newItem | amount = value }
    in
        { state | newItem = newItem_ }


noMsg model =
    ( model, Nothing )


view : State -> List String -> Html Msg
view state payers =
    div []
        [ div [ class "existing-items" ] (List.map (itemFormView payers) state.items)
        , div []
            [ itemFormView payers state.newItem
            ]
        ]


itemFormView payers itemForm =
    div [ class "form-horizontal" ]
        [ div [ class "form-group" ]
            [ div [ class "col-xs-12 col-sm-3" ]
                [ select
                    [ class "form-control"
                    , onInput UpdateNewPayer
                    , value itemForm.payer
                    ]
                    (payerOptions itemForm payers)
                ]
            , div [ class "col-xs-12 col-sm-6" ]
                [ input
                    [ class "form-control"
                    , placeholder "Name"
                    , onInput UpdateNewName
                    , ViewUtil.onKeyEnter AddItem
                    , value itemForm.name
                    ]
                    []
                ]
            , div [ class "col-xs-12 col-sm-3" ]
                [ input
                    [ class "form-control"
                    , type_ "number"
                    , placeholder "Amount"
                    , onInput UpdateNewAmount
                    , ViewUtil.onKeyEnter AddItem
                    , value itemForm.amount
                    ]
                    []
                ]
            ]
        ]


payerOptions : ItemForm -> List String -> List (Html msg)
payerOptions { payer } payers =
    let
        tail =
            payers
                |> List.map
                    (\payer_ ->
                        option [ value payer_ ] [ text payer_ ]
                    )
    in
        option [ value "Group" ] [ text "Group" ] :: tail
