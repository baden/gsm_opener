-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/web_sockets.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import WS
import Json.Encode as JE


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


echoServer : String
echoServer =
    "ws://localhost:9112/websocket"



-- MODEL


type alias Model =
    { input : String
    , messages : List String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" [], Cmd.none )



-- UPDATE


type Msg
    = Input String
    | Connect
    | Send
    | NewMessage String
    | WebsocketOpen String
    | WebsocketClose String
    | WebsocketMessage String
    | WebsocketError String


listingDetailsRequest : String -> JE.Value
listingDetailsRequest url =
    JE.object
        [ ( "url", JE.string url )
        , ( "mobile", JE.bool False ) -- TODO: Either re-wire up a mobile flag when mobile layout is back, or remove this
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg { input, messages } =
    case msg of
        Input newInput ->
            ( Model newInput messages, Cmd.none )

        Connect ->
            ( Model "" messages
            , Cmd.batch
                [ WS.websocketConnect <| listingDetailsRequest "bbb"
                ]
            )

        Send ->
            ( Model "" messages, WebSocket.send echoServer input )

        NewMessage str ->
            let
                _ =
                    Debug.log "NewMessage" 0
            in
                ( Model input (str :: messages), Cmd.none )

        WebsocketOpen str ->
            let
                _ =
                    Debug.log "WebsocketOpen" str
            in
                ( Model "" messages, Cmd.none )

        WebsocketClose str ->
            let
                _ =
                    Debug.log "WebsocketClose" str
            in
                ( Model "" messages, Cmd.none )

        WebsocketMessage str ->
            let
                _ =
                    Debug.log "WebsocketMessage" str
            in
                ( Model "" messages, Cmd.none )

        WebsocketError str ->
            let
                _ =
                    Debug.log "WebsocketError" str
            in
                ( Model "" messages, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick Connect ] [ text "Connect" ] ]
        , div
            []
            [ input [ onInput Input, value model.input ] []
            , button [ onClick Send ] [ text "Link" ]
            , button [ onClick Send ] [ text "Link" ]
            , div [] (List.map viewMessage (List.reverse model.messages))
            ]
        ]


viewMessage : String -> Html msg
viewMessage msg =
    div [] [ text msg ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ WebSocket.listen echoServer NewMessage
        , WS.websocketOpen WebsocketOpen
        , WS.websocketClose WebsocketClose
        , WS.websocketMessage WebsocketMessage
        , WS.websocketError WebsocketError
        ]
