module Pages.DeviceList exposing (Model, Config, init, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Receive exposing (DeviceInfo)


type alias Model =
    { a : String
    }


type alias Config msg =
    { onClickAdd : msg
    , onChooseDevice : String -> msg
    }


init : Model
init =
    { a = "TBD"
    }


view : List ( String, DeviceInfo ) -> Config msg -> Html msg
view m config =
    div [ class "device_list" ]
        [ m
            |> List.map (\e -> viewDeviceItem e config)
            |> ul [ class "device_list" ]
        , div [ class "bottom_panel" ]
            [ micmd "add_circle_outline" config.onClickAdd
            , mi "widgets"
            ]
        ]



--


viewDeviceItem : ( String, DeviceInfo ) -> Config msg -> Html msg
viewDeviceItem ( title, d ) config =
    li [ class "device_item" ]
        [ mi "settings"
        , div [ class "chooser", onClick (config.onChooseDevice d.id) ]
            [ div [ class "label" ] [ text <| title ]
            , div [ class "id" ] [ text <| d.id ]
            ]
        , mi "link"
        ]


mi : String -> Html msg
mi d =
    i [ class "material-icons" ] [ text d ]


micmd : String -> msg -> Html msg
micmd d msg =
    i [ class "material-icons", onClick msg ] [ text d ]
