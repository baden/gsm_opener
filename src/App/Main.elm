module Main exposing (..)

import Update
    exposing
        ( Model
        , PageModel(..)
        , Msg(..)
          -- , PageMessage(..)
        , ConnectStatus(..)
        , init
        , update
        )
import Html exposing (..)
import Html.Attributes exposing (..)
import WS
import Json.Encode as JE
import Session
import Dict
import Receive exposing (DeviceInfo)


-- import ControlPanel
-- import Device

import Pages.AddDevice as AddDevice
import Pages.HomeScreen as HomeScreen
import Pages.DeviceList as DeviceList
import Pages.DeviceSettings as DeviceSettings
import Widgets.Popups as Popups


main : Program JE.Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


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
        div [ class "root" ]
            [ case model.pageModel of
                AddDeviceModel ->
                    let
                        disabledLink =
                            case model.imei of
                                "" ->
                                    True

                                id ->
                                    List.any (\d -> d.id == id) model.links
                    in
                        AddDevice.view
                            { onImei = OnIMEI
                            , onLabel = OnLabel
                            , onAdd = Send
                            , onCancel = SendCancel
                            , imei = model.imei
                            , label = model.label
                            , disabled = disabledLink
                            , nocancel = List.isEmpty model.links
                            }

                HomeScreenModel m ->
                    let
                        id =
                            "123"

                        device =
                            model.devices
                                |> Dict.get id
                                |> Maybe.withDefault (Receive.deviceDefault id)
                    in
                        HomeScreen.view
                            { device = device }
                            m
                            |> Html.map HomeScreenMsg

                DeviceListModel m ->
                    let
                        devices =
                            model.links
                                |> List.map
                                    (\l ->
                                        let
                                            id =
                                                l.id

                                            title =
                                                l.title
                                        in
                                            model.devices
                                                |> Dict.get id
                                                |> Maybe.withDefault (Receive.deviceDefault id)
                                                |> (\e -> ( title, e ))
                                    )
                    in
                        DeviceList.view devices
                            { onClickAdd = OnClickAdd
                            , onChooseDevice = OnChooseDevice
                            }

                DeviceSettingsModel m ->
                    DeviceSettings.view m
            , Popups.view model.popups
            ]



-- div []
--     [ ControlPanel.view model
--     , div [ class "main_panel", style styles ]
--         [ ul [ class "device_list" ] <|
--             (model.links
--                 |> List.map
--                     (\id ->
--                         model.devices
--                             |> Dict.get id
--                             |> Maybe.withDefault (Receive.deviceDefault id)
--                             |> Device.viewDevice
--                     )
--             )
--         ]
--     ]


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
