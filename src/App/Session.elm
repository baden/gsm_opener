module Session
    exposing
        ( User
        , Item
        , sessionChange
        , resetSession
        , storeSession
        , decodeUserFromJson
        )

import Json.Encode as JE
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Util exposing ((=>))
import WS


type alias User =
    { token : String
    , links :
        List Item
        -- { email : String
        -- , token : AuthToken
        -- , username : Username
        -- , bio : Maybe String
        -- , image : UserPhoto
        -- , createdAt : String
        -- , updatedAt : String
    }


type alias Item =
    { title : String
    , id : String
    }


itemDecoder : Decoder Item
itemDecoder =
    decode Item
        |> Pipeline.required "title" Decode.string
        |> Pipeline.required "id" Decode.string


userDecoder : Decoder User
userDecoder =
    decode User
        |> Pipeline.required "token" Decode.string
        |> Pipeline.required "links" (Decode.list itemDecoder)



--
--
-- |> required "email" Decode.string
-- |> required "token" AuthToken.decoder
-- |> required "username" usernameDecoder
-- |> required "bio" (Decode.nullable Decode.string)
-- |> required "image" UserPhoto.decoder
-- |> required "createdAt" Decode.string
-- |> required "updatedAt" Decode.string
--
--


itemEncode : Item -> JE.Value
itemEncode item =
    JE.object
        [ "title" => JE.string item.title
        , "id" => JE.string item.id
        ]


userEncode : User -> JE.Value
userEncode user =
    JE.object
        [ "token" => JE.string user.token
        , "links"
            => JE.list (List.map itemEncode user.links)
          -- [ "email" => Encode.string user.email
          -- , "token" => AuthToken.encode user.token
          -- , "username" => encodeUsername user.username
          -- , "bio" => EncodeExtra.maybe Encode.string user.bio
          -- , "image" => UserPhoto.encode user.image
          -- , "createdAt" => Encode.string user.createdAt
          -- , "updatedAt" => Encode.string user.updatedAt
        ]


sessionChange : Sub (Maybe User)
sessionChange =
    WS.onSessionChange (Decode.decodeValue userDecoder >> Result.toMaybe)



-- Где-то явно избыточный код


decodeUserFromJson : JE.Value -> Maybe User
decodeUserFromJson json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString userDecoder >> Result.toMaybe)


resetSession : Cmd msg
resetSession =
    WS.storeSession Nothing


storeSession : User -> Cmd msg
storeSession user =
    userEncode user
        |> JE.encode 0
        |> Just
        |> WS.storeSession
