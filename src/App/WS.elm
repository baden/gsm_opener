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



-- port websocketConnect : String -> Cmd msg


port websocketDisconnect : Payload -> Cmd msg


port websocketSend : Payload -> Cmd msg



-- -- Receive from JS (Sub)
--
--
-- port websocketReceive : (( Topic, Event, Payload ) -> msg) -> Sub msg
--
--
--
-- -- Send to JS (Cmd)
--
--
-- port websocketSend : ( Topic, Event, Payload ) -> Cmd msg
--
--
-- port websocketListen : ( Topic, Event ) -> Cmd msg
