module Update
    exposing
        ( Model
        , Msg(..)
        , ConnectStatus(..)
        , init
        , update
        )

import Dict
import Receive exposing (DeviceInfo)
import Session
import Json.Encode as JE
import Json.Decode as JD exposing (Decoder)
import WS
import Server
import Task
import Time exposing (Time)
import Process


type ConnectStatus
    = CS_Disconnected
    | CS_Connected


type alias Model =
    { input : String
    , links : List String
    , connectStatus : ConnectStatus
    , devices : Dict.Dict String DeviceInfo
    }


type alias Id =
    String


type Msg
    = Input String
    | Connect
    | Send
    | Unlink String
    | WebsocketOpen String
    | WebsocketClose String
    | WebsocketMessage JE.Value
    | WebsocketError String
    | SetUser (Maybe Session.User)
    | Control Id String


init : JE.Value -> ( Model, Cmd Msg )
init flags =
    let
        session =
            Session.decodeUserFromJson flags

        _ =
            Debug.log "init" session

        links =
            case session of
                Nothing ->
                    []

                Just s ->
                    s.links
    in
        ( { input = ""
          , links = links
          , connectStatus = CS_Disconnected
          , devices = Dict.empty
          }
        , Cmd.batch [ delay (Time.second * 1) Connect ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input newInput ->
            ( { model | input = newInput }, Cmd.none )

        Connect ->
            ( model
            , Cmd.batch
                [ WS.websocketConnect <| listingDetailsRequest "bbb"
                ]
            )

        Send ->
            let
                newLinks =
                    model.links ++ [ model.input ]
            in
                ( { model | input = "", links = newLinks }
                , Cmd.batch
                    [ Server.wsSendLinks newLinks
                    , Session.storeSession { token = "notoken", links = newLinks }
                    ]
                )

        Unlink id ->
            let
                newLinks =
                    List.filter ((/=) id) model.links
            in
                ( { model | links = newLinks }
                , Cmd.batch
                    [ Server.wsSendLinks newLinks
                    , Session.storeSession { token = "notoken", links = newLinks }
                    ]
                )

        WebsocketOpen str ->
            let
                _ =
                    Debug.log "WebsocketOpen" str
            in
                ( { model | connectStatus = CS_Connected }
                , Server.wsSendLinks model.links
                )

        WebsocketClose str ->
            let
                _ =
                    Debug.log "WebsocketClose" str
            in
                ( { model | connectStatus = CS_Disconnected }
                , Cmd.batch
                    [ delay (Time.second * 5) Connect
                    ]
                )

        WebsocketMessage str ->
            let
                _ =
                    Debug.log "WebsocketMessage" str
            in
                receive str model

        WebsocketError str ->
            let
                _ =
                    Debug.log "WebsocketError" str
            in
                ( model, Cmd.none )

        SetUser u ->
            let
                _ =
                    Debug.log "SetUser" u
            in
                case u of
                    Nothing ->
                        ( model, Cmd.none )

                    Just s ->
                        ( { model | links = s.links }, Cmd.none )

        Control id cmd ->
            ( model, Cmd.batch [ Server.wsSendCmd id cmd, beep "0" ] )


beep : String -> Cmd Msg
beep id_ =
    WS.beep id_


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


listingDetailsRequest : String -> JE.Value
listingDetailsRequest url =
    JE.object
        [ ( "url", JE.string url )
        , ( "mobile", JE.bool False )
          -- TODO: Either re-wire up a mobile flag when mobile layout is back, or remove this
        ]


receive : JE.Value -> Model -> ( Model, Cmd Msg )
receive msg model =
    case JD.decodeValue Receive.decoder msg of
        Ok msgs ->
            let
                m =
                    msgs
                        |> List.foldl receiveUpdater model
            in
                -- ( m, Cmd.none )
                ( m, Cmd.batch [ beep "0" ] )

        -- Ok (Receive.ReceiveCmdDevice u) ->
        --     ( { model | devices = Dict.insert u.id u model.devices }, Cmd.none )
        --
        -- Ok Receive.ReceiveCmdUnexpected ->
        --     ( model, Cmd.none )
        Err _ ->
            ( model, Cmd.none )


receiveUpdater : Receive.ReceiveCmd -> Model -> Model
receiveUpdater cmd model =
    case cmd of
        Receive.ReceiveCmdDevice d ->
            { model | devices = Dict.insert d.id d model.devices }

        Receive.ReceiveCmdUnexpected ->
            model
