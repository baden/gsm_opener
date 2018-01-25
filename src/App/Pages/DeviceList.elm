module Pages.DeviceList exposing (Model, init, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Receive exposing (DeviceInfo)


type alias Model =
    { a : String
    }


init : Model
init =
    { a = "TBD"
    }


view : List DeviceInfo -> Html msg
view m =
    div [ class "device_list" ]
        [ m
            |> List.map viewDeviceItem
            |> ul [ class "device_list" ]
        , div [ class "bottom_panel" ]
            [ mi "add_circle_outline"
            ]
        ]


viewDeviceItem : DeviceInfo -> Html msg
viewDeviceItem d =
    li [ class "device_item" ]
        [ mi "settings"
        , div []
            [ div [ class "label" ] [ text <| "Хата" ]
            , div [ class "id" ] [ text <| "123" ]
            ]
        , mi "link"
        ]


mi : String -> Html msg
mi d =
    i [ class "material-icons" ] [ text d ]
