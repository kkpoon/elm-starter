module Main exposing (..)

import Html exposing (Html, div, text)
import Html.App
import Navigation
import Auth.Models
import Auth.Messages
import Auth.Update
import Auth.LoginView
import Routing exposing (Route(..))



-- MODEL


type alias Model =
    { authInfo : Auth.Models.AuthInfo
    , route : Route
    }


init : Result String Route -> ( Model, Cmd Msg )
init result =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        ( Model Auth.Models.newAuthInfo currentRoute, Cmd.none )



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



urlUpdate : Result String Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        ( { model | route = currentRoute }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ page model ]



page : Model -> Html Msg
page model =
    case model.route of
        LoginRoute ->
            Html.App.map AuthMsg (Auth.LoginView.view model.authInfo)
        MemberAreaRoute ->
            text "member"
        NotFoundRoute ->
            text "404"



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- MAIN


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
