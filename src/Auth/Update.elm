module Auth.Update exposing (..)

import Auth.Messages exposing (Msg(..))
import Auth.Models exposing (AuthInfo)
import Auth.Commands exposing (login)



update : Msg -> AuthInfo -> ( AuthInfo, Cmd Msg )
update message model =
    case Debug.log "AuthMsg" message of

        EnterUsername username ->
            ( { model | username = username }, Cmd.none )

        EnterPassword password ->
            ( { model | password = password }, Cmd.none )

        PressLoginButton ->
            ( model, login model.username model.password )

        LoginSuccess username token ->
            ( { model | username = username, token = token, password = "", authenticated = True, errorMessage = "" }, Cmd.none )

        LoginFail errorMessage ->
            ( { model | token = "", password = "", authenticated = False, errorMessage = errorMessage }, Cmd.none )