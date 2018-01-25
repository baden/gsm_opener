module Device exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Update exposing (Model, Msg(..), ConnectStatus(..))
import Receive exposing (DeviceInfo)
import Json.Decode as JD exposing (Decoder)
import Widgets.SimpleCommand


viewDevice : DeviceInfo -> Html Msg
viewDevice d =
    li [ class "device" ]
        [ deviceHeader d
        , deviceBody d
        ]


deviceHeader : DeviceInfo -> Html Msg
deviceHeader d =
    div [ class "device-header" ]
        [ connectionIcon d.connected
        , span []
            [ text <|
                "ID: "
                    ++ d.id
                    ++ if not d.connected then
                        " Не подключен"
                       else
                        ""
            ]
        , closeIcon d.id
        ]


deviceBody : DeviceInfo -> Html Msg
deviceBody d =
    let
        state =
            case d.connected of
                True ->
                    ""

                False ->
                    " not_connected"
    in
        div [ class <| "device-body" ++ state ]
            [ --div [] [ text "Входы: " ]
              div []
                [ inputIcon d.in1
                , inputIcon d.in2
                , inputIcon d.in3
                , inputIcon d.in4
                ]
              -- , div [] [ text "Выходы: " ]
            , div []
                [ outputIcon d.out1
                , outputIcon d.out2
                , outputIcon d.out3
                , outputIcon d.out4
                ]
              -- , div [] [ text "Управление: " ]
            , div []
                [ Widgets.SimpleCommand.view { label = "Открыть", onClick = (Control d.id "out1") }
                ]
              -- , div [] [ text " Счетчик: " ]
            , div [] [ text " Счетчик: ", text d.counter ]
            ]


connectionIcon : Bool -> Html Msg
connectionIcon connected =
    i
        [ class "material-icons"
        , style
            [ ( "color"
              , if connected then
                    "green"
                else
                    "red"
              )
            ]
        ]
        [ text "wifi" ]


closeIcon : String -> Html Msg
closeIcon id =
    i [ class "material-icons", title "Удалить", onClick <| Unlink id ] [ text "close" ]


onTouchStart : msg -> Attribute msg
onTouchStart msg =
    on "touchstart" (JD.succeed msg)


inputIcon : String -> Html Msg
inputIcon state =
    let
        pclass =
            case state of
                "-1" ->
                    ""

                "0" ->
                    " passive"

                "1" ->
                    " active"

                _ ->
                    ""
    in
        i
            [ class <| "input material-icons" ++ pclass
            , title "Вход"
            ]
            [ text "input" ]


outputIcon : String -> Html Msg
outputIcon state =
    let
        pclass =
            case state of
                "-1" ->
                    ""

                "0" ->
                    " passive"

                "1" ->
                    " active"

                _ ->
                    ""
    in
        i
            [ class <| "output material-icons" ++ pclass
            , title "Выход"
            ]
            [ text "lightbulb_outline" ]



-- type alias Touch =
--     { clientX : Float
--     , clientY : Float
--     }
--
--
-- touchDecoder : JD.Decoder Touch
-- touchDecoder =
--     JD.map2 Touch
--         (JD.field "clientX" JD.float)
--         (JD.field "clientY" JD.float)
--
--
-- eventDecoder : (Touch -> msg) -> String -> JD.Decoder msg
-- eventDecoder msg eventKey =
--     JD.at [ eventKey, "0" ] (JD.map msg touchDecoder)
-- onTouchStart : (Touch -> msg) -> Attribute msg
-- onTouchStart msg =
--     -- on "touchstart" <| eventDecoder msg "touches"
-- onTouchStart UserSwipeStart
-- TODO: Тут бып сделать только существующие состояния
