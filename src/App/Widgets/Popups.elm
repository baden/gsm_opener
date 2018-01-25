module Widgets.Popups exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type PopupFrom
    = PopupLeft
    | PopupRight


type alias Popup =
    { from : PopupFrom
    }


type alias Popups =
    List Popup


viewPopup : Popup -> Html msg
viewPopup p =
    div [ class "popup" ]
        [ mi "input"
        , span [] [ text "Хата" ]
        ]


view : Popups -> Html msg
view pp =
    pp
        |> List.map viewPopup
        |> div [ class "pupups" ]


mi : String -> Html msg
mi d =
    i [ class "material-icons" ] [ text d ]
