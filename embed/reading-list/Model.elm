module Model exposing (..)


type alias Book =
    { title : String
    , author : String
    , rating : Int
    }


type alias Form =
    { title : String
    , author : String
    , rating : String
    , errors : List ( String, String )
    , dirty : Bool
    }


type alias Model =
    { books : List Book
    , addForm : Form
    , showDialog : Bool
    , editForm : Form
    , selectedIndex : Int
    }


defaultForm : Form
defaultForm =
    { title = "", author = "", rating = "3", errors = [], dirty = False }
