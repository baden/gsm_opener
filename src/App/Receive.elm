module Receive exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type ReceiveCmd
    = ReceiveCmdDevice DeviceInfo
    | ReceiveCmdUnexpected



-- Декодер для объекта-сообщения "device"


type alias DeviceInfo =
    { id : String
    , connected : Bool
    , counter : String
    }


deviceInfoDecoder : Decoder DeviceInfo
deviceInfoDecoder =
    decode DeviceInfo
        |> Pipeline.required "id" JD.string
        |> Pipeline.required "connected" JD.bool
        |> Pipeline.optional "counter" JD.string ""



-- Декодер для объекта-сообщения


receiveDecoder : Decoder ReceiveCmd
receiveDecoder =
    decode toReceiveItem
        |> Pipeline.required "k" JD.string
        |> Pipeline.required "v" JD.value
        |> Pipeline.resolve


toReceiveItem : String -> JE.Value -> Decoder ReceiveCmd
toReceiveItem k v =
    case k of
        "device" ->
            case v |> JD.decodeValue deviceInfoDecoder of
                Ok di ->
                    JD.succeed <| ReceiveCmdDevice di

                Err _ ->
                    JD.fail "Error parse updare payload"

        _ ->
            JD.fail "Unknows cmd"



-- Декодер для массива объектов-сообщений


decoder : Decoder (List ReceiveCmd)
decoder =
    JD.list receiveDecoder
