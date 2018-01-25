module Pages.AddDevice exposing (view, Config)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Config msg =
    { onImei : String -> msg
    , onLabel : String -> msg
    , onAdd : msg
    , onCancel : msg
    , imei : String
    , label : String
    , disabled : Bool
    , nocancel : Bool
    }


view : Config msg -> Html msg
view config =
    div [ class "add_device" ] <|
        [ div [ class "label" ] [ text "IMEI" ]
        , div [ class "input" ] [ input [ onInput config.onImei, value config.imei ] [] ]
        , div [ class "label" ] [ text "Найменування" ]
        , div [ class "input" ] [ input [ onInput config.onLabel, value config.label ] [] ]
        , button [ class "button", onClick config.onAdd, disabled config.disabled ] [ mi "add_circle_outline", text "Додати" ]
        ]
            ++ if config.nocancel then
                []
               else
                [ button [ class "button red", onClick config.onCancel ] [ mi "cancel", text "Вiдмiна" ] ]


mi : String -> Html msg
mi d =
    i [ class "material-icons" ] [ text d ]
