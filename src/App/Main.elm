module Main exposing (..)

import Update exposing (Model, Msg(..), ConnectStatus(..), init, update)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WS
import Json.Encode as JE
import Session
import Dict
import Receive exposing (DeviceInfo)
import ControlPanel
import Device


main : Program JE.Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- echoServer : String
-- echoServer =
--     "ws://localhost:9112/websocket"
-- type alias ReceiveUpdate =
--     { name : String
--     , id : String
--     , values : DeviceInfo
--     }
-- Возможно в перспективе сюда нужно будет добавить массив для Cmd.batch
-- View


view : Model -> Html Msg
view model =
    let
        styles =
            case model.connectStatus of
                CS_Connected ->
                    []

                _ ->
                    [ ( "pointer-events", "none" ), ( "opacity", "0.3" ) ]
    in
        div []
            [ ControlPanel.view model
            , div [ class "main_panel", style styles ]
                [ ul [ class "device_list" ] <|
                    (model.links
                        |> List.map
                            (\id ->
                                model.devices
                                    |> Dict.get id
                                    |> Maybe.withDefault (Receive.deviceDefault id)
                                    |> Device.viewDevice
                            )
                    )
                ]
            ]


viewMessage : String -> Html msg
viewMessage msg =
    div [] [ text msg ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ WS.websocketOpen WebsocketOpen
        , WS.websocketClose WebsocketClose
        , WS.websocketMessage WebsocketMessage
        , WS.websocketError WebsocketError
        , Sub.map SetUser Session.sessionChange
        ]
