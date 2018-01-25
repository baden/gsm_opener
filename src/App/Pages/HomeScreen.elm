module Pages.HomeScreen exposing (Model, Msg, Config, ParentMsg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Receive exposing (DeviceInfo)


type alias Model =
    { inform : String
    }


type Msg
    = NoOp
    | ClickSettings
    | ClickAction


type alias Config =
    { device : DeviceInfo
    }


type ParentMsg
    = OnSettings
    | OnAction


init : Model
init =
    { inform = "Немає зв'язку з замком"
    }


update : Msg -> Model -> ( Model, Maybe ParentMsg )
update msg model =
    let
        _ =
            Debug.log "HomeScreen update" ( msg, model )
    in
        case msg of
            NoOp ->
                ( model, Nothing )

            ClickSettings ->
                ( { model | inform = "Clicked settings" }, Just OnSettings )

            ClickAction ->
                ( { model | inform = "Clicked action" }, Just OnAction )


view : Config -> Model -> Html Msg
view c m =
    div [ class "home_screen" ]
        [ viewHeader c m
        , viewMain c m
        , viewStatusbar c m
        ]


viewHeader : Config -> Model -> Html Msg
viewHeader c m =
    div [ class "home_screen_header" ]
        [ span [] [ text "Прохiдна 1" ]
        , micmd "settings" ClickSettings
        ]


viewMain : Config -> Model -> Html Msg
viewMain c m =
    let
        _ =
            Debug.log "d" c.device.in2

        iclass =
            case c.device.in2 of
                "0" ->
                    " passive"

                "1" ->
                    " active"

                _ ->
                    ""

        oclass =
            case c.device.out1 of
                "0" ->
                    " passive"

                "1" ->
                    " active"

                _ ->
                    ""
    in
        div [ class "home_screen_main" ]
            [ div [ class "big_control", onClick ClickAction ] [ mi "fingerprint" ]
            , div [ class <| "small_info_lt" ++ iclass ] [ mi "input" ]
            , div [ class <| "small_info_rt" ++ oclass ] [ mi "lock_open" ]
            ]


viewStatusbar : Config -> Model -> Html Msg
viewStatusbar c m =
    div [ class "home_screen_statusbar" ]
        [ div [ class "inform_line" ] [ text m.inform ]
        , div [ class "link_status" ]
            [ span [ class "point" ] [ mi "tablet_mac" ]
            , span [] [ text "o o o" ]
            , span [ class "point" ] [ mi "cloud" ]
            , span [] [ text "o o o" ]
            , span [ class "point" ] [ mi "lock" ]
            ]
        ]


mi : String -> Html Msg
mi d =
    i [ class "material-icons" ] [ text d ]


micmd : String -> Msg -> Html Msg
micmd d msg =
    i [ class "material-icons", onClick msg ] [ text d ]
