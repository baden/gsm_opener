module Widgets.SimpleCommand exposing (view, Config)

import Html exposing (Html, div, text, span, i)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Config msg =
    { label : String
    , onClick : msg
    }


view : Config msg -> Html msg
view config =
    div [ class <| "simple_command noselect", onClick config.onClick ]
        [ span []
            [ i
                [ class "material-icons"
                , title "Активировать/Деактивировать"
                ]
                [ text "lock_open" ]
            , Html.br [] []
            , text config.label
            ]
        ]
