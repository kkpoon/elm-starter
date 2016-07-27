module Main exposing (..)

import Html exposing (Html, div)
import Html.App
import Auth.Models
import Auth.Messages
import Auth.Update
import Auth.LoginView



-- MODEL


type alias Model =
    { authInfo : Auth.Models.AuthInfo
    }


init : ( Model, Cmd Msg )
init =
    ( Model Auth.Models.newAuthInfo, Cmd.none )



-- MESSAGES


type Msg
    = AuthMsg Auth.Messages.Msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthMsg authMsg ->
            let
                ( updatedAuthInfo, cmd ) =
                    Auth.Update.update authMsg model.authInfo
            in
                ( { model | authInfo = updatedAuthInfo }
                , Cmd.map AuthMsg cmd
                )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.App.map AuthMsg (Auth.LoginView.view model.authInfo) ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
