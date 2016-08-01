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
    case error of
        Http.Timeout ->
            LoginFail "Timeout"
        Http.NetworkError ->
            LoginFail "Network error"
        Http.UnexpectedPayload payload ->
            LoginFail (concat ["Unexpected payload: ", payload])
        Http.BadResponse code body ->
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
    let
        encodedBaseAuth = concat ["Basic ", encodeBasicAuth username password]
    in
        Http.send Http.defaultSettings
            { verb = "POST"
            , headers = [( "Authorization", encodedBaseAuth )]
            , url = "/login"
            , body = Http.empty
            }
            |> Http.fromJson loginResponseDecoder
            |> Task.perform handleError handleSuccess
