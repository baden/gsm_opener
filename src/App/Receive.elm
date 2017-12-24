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
    , in1 : String
    , in2 : String
    , in3 : String
    , in4 : String
    , out1 : String
    , out2 : String
    , out3 : String
    , out4 : String
    }


deviceDefault : String -> DeviceInfo
deviceDefault id =
    { id = id
    , connected = False
    , counter = ""
    , in1 = "-1"
    , in2 = "-1"
    , in3 = "-1"
    , in4 = "-1"
    , out1 = "-1"
    , out2 = "-1"
    , out3 = "-1"
    , out4 = "-1"
    }


deviceInfoDecoder : Decoder DeviceInfo
deviceInfoDecoder =
    decode DeviceInfo
        |> Pipeline.required "id" JD.string
        |> Pipeline.required "connected" JD.bool
        |> Pipeline.optional "counter" JD.string ""
        |> Pipeline.optional "in1" JD.string "-1"
        |> Pipeline.optional "in2" JD.string "-1"
        |> Pipeline.optional "in3" JD.string "-1"
        |> Pipeline.optional "in4" JD.string "-1"
        |> Pipeline.optional "out1" JD.string "-1"
        |> Pipeline.optional "out2" JD.string "-1"
        |> Pipeline.optional "out3" JD.string "-1"
        |> Pipeline.optional "out4" JD.string "-1"



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
