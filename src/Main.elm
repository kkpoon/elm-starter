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


init : Result String Route -> ( Model, Cmd a )
init result =
    let
        authInfo =
            Auth.Models.newAuthInfo
        routeResult =
            Routing.nextRoute result (Routing.Model authInfo)
    in
        case routeResult of
            Ok route ->
                ( Model authInfo route, Cmd.none )
            Err cmd ->
                ( Model authInfo UnauthorizedRoute, cmd )



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
                ( { model | authInfo = updatedAuthInfo }, Cmd.map AuthMsg cmd )



urlUpdate : Result String Route -> Model -> ( Model, Cmd a )
urlUpdate result model =
    let
        routeResult =
            Routing.nextRoute result (Routing.Model model.authInfo)
    in
        case routeResult of
            Ok route ->
                ( { model | route = route }, Cmd.none )
            Err cmd ->
                ( model, cmd )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ page model ]



page : Model -> Html Msg
page model =
    case model.route of
        IndexRoute ->
            text "index"
        LoginRoute ->
            Html.App.map AuthMsg (Auth.LoginView.view model.authInfo)
        MemberAreaRoute ->
            text "member"
        UnauthorizedRoute ->
            text "403"
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
