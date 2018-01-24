module ControlPanel exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Update exposing (Model, Msg(..), ConnectStatus(..))


view : Model -> Html Msg
view model =
    let
        disabledLink =
            case model.input of
                "" ->
                    True

                id ->
                    List.member id model.links
    in
        div [ class "control_panel" ]
            [ view_connectStatus model.connectStatus
            , input [ onInput Input, value model.input ] []
            , button [ onClick Send, disabled disabledLink ] [ text "Подключиться" ]
            ]


view_connectStatus : ConnectStatus -> Html a
view_connectStatus cs =
    let
        color =
            case cs of
                CS_Disconnected ->
                    "#d20000"

                CS_Connected ->
                    "#00d200"
    in
        div [ title "Состояние подключения к серверу", style [ ( "display", "inline-block" ) ] ]
            [ i [ class "material-icons", style [ ( "font-size", "32px" ), ( "color", color ) ] ] [ text "wifi" ]
            ]
