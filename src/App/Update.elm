module Update
    exposing
        ( Model
        , PageModel(..)
        , Msg(..)
          -- , PageMessage(..)
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


-- import Pages.AddDevice as AddDevice

import Pages.HomeScreen as HomeScreen
import Pages.DeviceList as DeviceList
import Pages.DeviceSettings as DeviceSettings
import Widgets.Popups as Popups


type ConnectStatus
    = CS_Disconnected
    | CS_Connected



-- type Page
--     = AddDevicePage
--     | HomeScreenPage
--     | DeviceListPage
--     | DeviceSettingsPage


type PageModel
    = AddDeviceModel
    | HomeScreenModel HomeScreen.Model
    | DeviceListModel DeviceList.Model
    | DeviceSettingsModel DeviceSettings.Model


type alias Model =
    { imei : String
    , label : String
    , links : List Session.Item
    , connectStatus : ConnectStatus
    , devices : Dict.Dict String DeviceInfo
    , pageModel : PageModel
    , popups : Popups.Popups
    }


type alias Id =
    String


type Msg
    = OnIMEI String
    | OnLabel String
    | OnClickAdd
    | Connect
    | Send
    | SendCancel
    | Unlink String
    | WebsocketOpen String
    | WebsocketClose String
    | WebsocketMessage JE.Value
    | WebsocketError String
    | SetUser (Maybe Session.User)
    | Control Id String
      -- | PageMsg PageMessage
    | HomeScreenMsg HomeScreen.Msg



-- type PageMessage
--     = HomeScreenMsg HomeScreen.Msg


init : JE.Value -> ( Model, Cmd Msg )
init flags =
    let
        session =
            Session.decodeUserFromJson flags

        _ =
            Debug.log "init" session

        ( links, page ) =
            case session of
                Nothing ->
                    ( [], AddDeviceModel )

                Just s ->
                    ( s.links, HomeScreenModel HomeScreen.init )
    in
        ( { imei = ""
          , label = ""
          , links = links
          , connectStatus = CS_Disconnected
          , devices = Dict.empty
          , pageModel = page
          , popups =
                []
                -- [ Popups.Popup Popups.PopupLeft
                -- , Popups.Popup Popups.PopupLeft
                -- ]
          }
        , Cmd.batch [ delay (Time.second * 1) Connect ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnIMEI v ->
            ( { model | imei = v }, Cmd.none )

        OnLabel v ->
            ( { model | label = v }, Cmd.none )

        OnClickAdd ->
            ( { model | pageModel = AddDeviceModel }, Cmd.none )

        Connect ->
            ( model
            , Cmd.batch
                [ WS.websocketConnect <| listingDetailsRequest "bbb"
                ]
            )

        Send ->
            let
                newLinks =
                    model.links ++ [ Session.Item model.imei model.label ]
            in
                ( { model
                    | imei = ""
                    , label = ""
                    , links = newLinks
                    , pageModel = HomeScreenModel HomeScreen.init
                  }
                , Cmd.batch
                    [ Server.wsSendLinks newLinks
                    , Session.storeSession { token = "notoken", links = newLinks }
                    ]
                )

        SendCancel ->
            ( { model
                | imei = ""
                , label =
                    ""
                    -- , pageModel = HomeScreenModel HomeScreen.init
                , pageModel = DeviceListModel DeviceList.init
              }
            , Cmd.none
            )

        Unlink id ->
            let
                newLinks =
                    List.filter (\i -> i.id /= id) model.links
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

        -- PageMsg m ->
        HomeScreenMsg sub_msg ->
            let
                _ =
                    Debug.log "PageMsg" m

                m =
                    case model.pageModel of
                        HomeScreenModel me ->
                            me

                        _ ->
                            Debug.crash "WTF"

                ( nm, p ) =
                    HomeScreen.update sub_msg m

                id =
                    "123"

                cmd =
                    "out1"
            in
                case p of
                    Nothing ->
                        ( { model | pageModel = HomeScreenModel nm }, Cmd.none )

                    Just (HomeScreen.OnSettings) ->
                        ( { model | pageModel = DeviceListModel DeviceList.init }, Cmd.none )

                    Just (HomeScreen.OnAction) ->
                        ( { model | pageModel = HomeScreenModel nm }
                        , Cmd.batch [ Server.wsSendCmd id cmd, beep "0" ]
                        )



-- ( model, Cmd.none )


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
