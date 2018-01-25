module Pages.AddDevice exposing (init, view, Model)

import Html exposing (..)


type alias Model =
    { a : String
    }


init : Model
init =
    { a = "init" }


view : Model -> Html msg
view m =
    div []
        [ text "TBD: AddDevice"
        ]
