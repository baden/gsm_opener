module Pages.DeviceList exposing (view, Model)

import Html exposing (..)


type alias Model =
    { a : String
    }


view : Model -> Html msg
view m =
    div []
        [ text "TBD: DeviceList"
        ]
