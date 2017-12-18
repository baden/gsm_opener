-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/web_sockets.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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
    , links : List String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" [] [], Cmd.none )



-- UPDATE


type Msg
    = Input String
    | Connect
    | Send
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
                a =
                    JE.object
                        [ ( "cmd", JE.string "link" )
                        , ( "params"
                          , JE.list
                                [ JE.string model.input
                                ]
                          )
                        ]
            in
                ( { model | input = "", links = model.links ++ [ model.input ] }, WS.websocketSend a )

        WebsocketOpen str ->
            let
                _ =
                    Debug.log "WebsocketOpen" str
            in
                ( model, Cmd.none )

        WebsocketClose str ->
            let
                _ =
                    Debug.log "WebsocketClose" str
            in
                ( model, Cmd.none )

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



-- VIEW


linkitem : String -> Html a
linkitem i =
    li [] [ text i ]


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick Connect ] [ text "Connect" ] ]
        , div
            []
            [ input [ onInput Input, value model.input ] []
            , button [ onClick Send ] [ text <| "Link to " ++ model.input ]
            , div [] (List.map viewMessage (List.reverse model.messages))
            ]
        , div []
            [ p [] [ text "Links:" ]
            , ul [] <|
                (model.links |> List.map linkitem)
            ]
        ]


viewMessage : String -> Html msg
viewMessage msg =
    div [] [ text msg ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ WS.websocketOpen WebsocketOpen
        , WS.websocketClose WebsocketClose
        , WS.websocketMessage WebsocketMessage
        , WS.websocketError WebsocketError
        ]
