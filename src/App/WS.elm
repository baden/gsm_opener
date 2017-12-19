-- TODO: Rename to Ports


port module WS exposing (..)

import Json.Encode


type alias Payload =
    Json.Encode.Value


type alias Topic =
    String


type alias Event =
    String


port websocketOpen : (String -> msg) -> Sub msg


port websocketClose : (String -> msg) -> Sub msg


port websocketMessage : (String -> msg) -> Sub msg


port websocketError : (String -> msg) -> Sub msg


port websocketConnect : Payload -> Cmd msg


port websocketDisconnect : Payload -> Cmd msg


port websocketSend : Payload -> Cmd msg


port storeSession : Maybe String -> Cmd msg


port onSessionChange : (Json.Encode.Value -> msg) -> Sub msg
