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
    div [ class <| "control noselect", onClick config.onClick ]
        [ span []
            [ i
                [ class "material-icons"
                , style [ ( "color", "red" ), ( "font-size", "18px" ), ( "cursor", "pointer" ) ]
                , title "Активировать/Деактивировать"
                ]
                [ text "face" ]
            , text config.label
            ]
        ]
