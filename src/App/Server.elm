module Server exposing (wsSendLinks, wsSendCmd)

import WS
import Json.Encode as JE


wsSendLinks : List String -> Cmd msg
wsSendLinks ls =
    let
        payload =
            JE.object
                [ ( "cmd", JE.string "link" )
                , ( "params"
                  , JE.list <|
                        (ls |> List.map (\l -> JE.string l))
                  )
                ]
    in
        WS.websocketSend payload


wsSendCmd : String -> String -> Cmd msg
wsSendCmd id cmd =
    let
        payload =
            JE.object
                [ ( "cmd", JE.string "do" )
                , ( "params"
                  , JE.object
                        [ ( "id", JE.string id )
                        , ( "cmd", JE.string cmd )
                        ]
                  )
                ]
    in
        WS.websocketSend payload
