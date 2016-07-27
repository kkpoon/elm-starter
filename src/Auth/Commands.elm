module Auth.Commands exposing (..)

import Http
import Json.Decode as Decode exposing ((:=))
import Task
import String exposing (concat)
import Base64
import Auth.Messages exposing (Msg(..))



type alias LoginResponse =
    { username : String
    , token : String
    }



loginResponseDecoder : Decode.Decoder LoginResponse
loginResponseDecoder =
    Decode.object2 LoginResponse
        ("username" := Decode.string)
        ("token" := Decode.string)



handleError : Http.Error -> Msg
handleError error =
    LoginFail "login failed"



handleSuccess : LoginResponse -> Msg
handleSuccess res =
    LoginSuccess res.username res.token



encodeBasicAuth : String -> String -> String
encodeBasicAuth username password =
    case Base64.encode (concat [username, ":", password]) of
        Ok value ->
            value
        Err error ->
            ""



login : String -> String -> Cmd Msg
login username password =
    Http.send Http.defaultSettings
        { verb = "POST"
        , headers = [( "Authorization", concat ["Basic ", encodeBasicAuth username password] )]
        , url = "/login"
        , body = Http.empty
        }
        |> Http.fromJson loginResponseDecoder
        |> Task.perform handleError handleSuccess
