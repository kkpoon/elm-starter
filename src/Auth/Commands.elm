module Auth.Commands exposing (login)

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Task
import String exposing (concat)
import Base64
import Auth.Messages exposing (Msg(..))


type alias LoginResponse =
    { username : String
    , token : String
    }


loginResponseDecoder : Decoder LoginResponse
loginResponseDecoder =
    decode LoginResponse
        |> required "username" Decode.string
        |> required "token" Decode.string


handleError : Http.Error -> Msg
handleError error =
    case error of
        Http.Timeout ->
            LoginFail "Timeout"

        Http.NetworkError ->
            LoginFail "Network error"

        Http.UnexpectedPayload payload ->
            LoginFail (concat [ "Unexpected payload: ", payload ])

        Http.BadResponse code body ->
            LoginFail "login failed"


handleSuccess : LoginResponse -> Msg
handleSuccess res =
    LoginSuccess res.username res.token


base64EncodeCredential : String -> String -> String
base64EncodeCredential username password =
    case Base64.encode (concat [ username, ":", password ]) of
        Ok value ->
            value

        Err error ->
            ""


login : String -> String -> Cmd Msg
login username password =
    let
        basicAuthHeader =
            concat [ "Basic ", base64EncodeCredential username password ]
    in
        Http.send Http.defaultSettings
            { verb = "POST"
            , headers = [ ( "Authorization", basicAuthHeader ) ]
            , url = "/login"
            , body = Http.empty
            }
            |> Http.fromJson loginResponseDecoder
            |> Task.perform handleError handleSuccess
