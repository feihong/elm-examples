module Msg exposing (..)


type AddFormMsg
    = ChangeTitle String
    | ChangeAuthor String
    | ChangeRating String


type EditFormMsg
    = ChangeEditTitle String
    | ChangeEditAuthor String
    | ChangeEditRating String


type Msg
    = NoOp
    | AddFormMsg AddFormMsg
    | EditFormMsg EditFormMsg
    | SubmitAddForm
    | SubmitEditForm
    | SelectBook Int
    | DeleteBook
    | CloseDialog
