-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/web_sockets.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WS
import Json.Encode as JE
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Task
import Time exposing (Time)
import Process
import Util exposing ((=>))


main : Program JE.Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


echoServer : String
echoServer =
    "ws://localhost:9112/websocket"


type ConnectStatus
    = CS_Disconnected
    | CS_Connected



-- MODEL


type alias Model =
    { input : String
    , messages : List String
    , links : List String
    , connectStatus : ConnectStatus
    }


init : JE.Value -> ( Model, Cmd Msg )
init flags =
    let
        _ =
            Debug.log "init" flags
    in
        ( { input = ""
          , messages = []
          , links = []
          , connectStatus = CS_Disconnected
          }
        , Cmd.batch [ delay (Time.second * 1) Connect ]
        )



-- UPDATE


type Msg
    = Input String
    | Connect
    | Send
    | Unlink String
    | WebsocketOpen String
    | WebsocketClose String
    | WebsocketMessage String
    | WebsocketError String
    | SaveSession
    | SetUser (Maybe User)


listingDetailsRequest : String -> JE.Value
listingDetailsRequest url =
    JE.object
        [ ( "url", JE.string url )
        , ( "mobile", JE.bool False ) -- TODO: Either re-wire up a mobile flag when mobile layout is back, or remove this
        ]


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


wsSendLinks : List String -> Cmd Msg
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
                ( { model | input = "", links = newLinks }, wsSendLinks newLinks )

        Unlink id ->
            let
                newLinks =
                    List.filter ((/=) id) model.links
            in
                ( { model | links = newLinks }, wsSendLinks newLinks )

        WebsocketOpen str ->
            let
                _ =
                    Debug.log "WebsocketOpen" str
            in
                ( { model | connectStatus = CS_Connected }, wsSendLinks model.links )

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
                ( model, Cmd.none )

        WebsocketError str ->
            let
                _ =
                    Debug.log "WebsocketError" str
            in
                ( model, Cmd.none )

        SaveSession ->
            ( model, storeSession { token = "notoken" } )

        SetUser u ->
            let
                _ =
                    Debug.log "SetUser" u
            in
                ( model, Cmd.none )


type alias User =
    { token : String

    -- { email : String
    -- , token : AuthToken
    -- , username : Username
    -- , bio : Maybe String
    -- , image : UserPhoto
    -- , createdAt : String
    -- , updatedAt : String
    }



--
--


userDecoder : Decoder User
userDecoder =
    decode User
        |> Pipeline.required "token" Decode.string



-- |> required "email" Decode.string
-- |> required "token" AuthToken.decoder
-- |> required "username" usernameDecoder
-- |> required "bio" (Decode.nullable Decode.string)
-- |> required "image" UserPhoto.decoder
-- |> required "createdAt" Decode.string
-- |> required "updatedAt" Decode.string


sessionChange : Sub (Maybe User)
sessionChange =
    WS.onSessionChange (Decode.decodeValue userDecoder >> Result.toMaybe)



--
--


resetSession =
    WS.storeSession Nothing


storeSession : User -> Cmd msg
storeSession user =
    userEncode user
        |> JE.encode 0
        |> Just
        |> WS.storeSession


userEncode : User -> JE.Value
userEncode user =
    JE.object
        [ "token" => JE.string user.token

        -- [ "email" => Encode.string user.email
        -- , "token" => AuthToken.encode user.token
        -- , "username" => encodeUsername user.username
        -- , "bio" => EncodeExtra.maybe Encode.string user.bio
        -- , "image" => UserPhoto.encode user.image
        -- , "createdAt" => Encode.string user.createdAt
        -- , "updatedAt" => Encode.string user.updatedAt
        ]



-- VIEW


view : Model -> Html Msg
view model =
    let
        styles =
            case model.connectStatus of
                CS_Connected ->
                    []

                _ ->
                    [ ( "pointer-events", "none" ), ( "opacity", "0.3" ) ]

        disabledLink =
            case model.input of
                "" ->
                    True

                id ->
                    List.member id model.links
    in
        div []
            [ div []
                [ view_connectStatus model.connectStatus
                , button [ onClick SaveSession ] [ text <| "Save" ]
                ]
            , div [ style styles ]
                [ div
                    []
                    [ input [ onInput Input, value model.input ] []
                    , button [ onClick Send, disabled disabledLink ] [ text <| "Link to " ++ model.input ]
                    , div [] (List.map viewMessage (List.reverse model.messages))
                    ]
                , div []
                    [ p [] [ text "Links:" ]
                    , ul [ class "device_list" ] <|
                        (model.links |> List.map viewDevice)
                    ]
                ]
            ]


closeIcon : String -> Html Msg
closeIcon id =
    i [ class "material-icons", style [ ( "color", "red" ), ( "font-size", "18px" ), ( "cursor", "pointer" ) ], title "Удалить", onClick <| Unlink id ] [ text "close" ]


conrtolIcon : String -> Html Msg
conrtolIcon id =
    i [ class "material-icons", style [ ( "color", "red" ), ( "font-size", "18px" ), ( "cursor", "pointer" ) ], title "Активировать/Деактивировать" ] [ text "face" ]


inputIcon : String -> Html Msg
inputIcon id =
    i [ class "material-icons", style [ ( "color", "green" ), ( "font-size", "18px" ) ], title "Вход 1" ] [ text "spa" ]


viewDevice : String -> Html Msg
viewDevice id =
    li [ class "device" ]
        [ span []
            [ text <| "ID: " ++ id
            ]
        , span []
            [ text "Входы: "
            , inputIcon id
            , inputIcon id
            , inputIcon id
            , inputIcon id
            , text " Выходы: "
            , button [ class "control" ] [ conrtolIcon id ]
            , button [ class "control" ] [ conrtolIcon id ]
            , button [ class "control" ] [ conrtolIcon id ]
            , button [ class "control" ] [ conrtolIcon id ]
            ]
        , closeIcon id
        ]


viewMessage : String -> Html msg
viewMessage msg =
    div [] [ text msg ]


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
        div [ title "Состояние подключения к серверу" ]
            [ i [ class "material-icons", style [ ( "font-size", "32px" ), ( "color", color ) ] ] [ text "wifi" ]
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ WS.websocketOpen WebsocketOpen
        , WS.websocketClose WebsocketClose
        , WS.websocketMessage WebsocketMessage
        , WS.websocketError WebsocketError
        , Sub.map SetUser sessionChange
        ]
