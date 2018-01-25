module Pages.HomeScreen exposing (Model, init, view)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { inform : String
    }


init : Model
init =
    { inform = "Немає зв'язку з замком" }


view : Model -> Html msg
view m =
    div [ class "home_screen" ]
        [ viewHeader m
        , viewMain m
        , viewStatusbar m
        ]


mi : String -> Html msg
mi d =
    i [ class "material-icons" ] [ text d ]


viewHeader : Model -> Html msg
viewHeader m =
    div [ class "home_screen_header" ]
        [ span [] [ text "Прохiдна 1" ]
        , mi "settings"
        ]


viewMain : Model -> Html msg
viewMain m =
    div [ class "home_screen_main" ]
        [ div [ class "big_control" ] [ mi "fingerprint" ]
        , div [ class "small_info_lt" ] [ mi "input" ]
        , div [ class "small_info_rt" ] [ mi "lock_open" ]
        ]


viewStatusbar : Model -> Html msg
viewStatusbar m =
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
