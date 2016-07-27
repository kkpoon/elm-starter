module Main exposing (..)

import Html exposing (Html, div, input, button, br, text)
import Html.App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Http
import Http exposing (defaultSettings)
import Json.Decode as Decode exposing ((:=))
import Task
import Base64
import String exposing (concat)



-- MAIN


main : Program Never
main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { username : String
  , password : String
  }


init : ( Model, Cmd Msg )
init =
  ( Model "" "", Cmd.none )



-- MESSAGES


type Msg
  = UpdateUsername String
  | UpdatePassword String
  | Login
  | LoginSuccess LoginResult
  | LoginFail Http.RawError



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateUsername username ->
      ( { model | username = username }, Cmd.none )

    UpdatePassword password ->
      ( { model | password = password }, Cmd.none )

    Login ->
      ( model, login)

    LoginSuccess result ->
      ( model, Cmd.none )

    LoginFail err ->
      ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Username", onInput UpdateUsername ] []
    , br [] []
    , input [ type' "password", placeholder "Password", onInput UpdatePassword ] []
    , br [] []
    , button [ onClick Login ] [ text "Login" ]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- COMMANDS


login : Cmd Msg
login =
  Http.send defaultSettings
    { verb = "POST"
    , headers = [("Authorization", encodeBasicAuth (concat ["", ":", ""]))]
    , url = "/login"
    , body = Http.empty
    }
    |> Task.perform LoginFail LoginSuccess

type alias LoginResult =
  { username : String
  , token : String
  }

loginResultDecoder : Decode.Decoder LoginResult
loginResultDecoder =
  Decode.object2 LoginResult
    ("username" := Decode.string)
    ("token" := Decode.string)


encodeBasicAuth : String -> String
encodeBasicAuth password =
  case Base64.encode password of
    Ok value ->
      value
    Err error ->
      ""
