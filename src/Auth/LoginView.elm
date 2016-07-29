module Auth.LoginView exposing (..)

import Html exposing (Html, div, input, br, button, p, text)
import Html.Attributes exposing (type', placeholder, value)
import Html.Events exposing (onInput, onClick)
import Auth.Messages exposing (..)
import Auth.Models exposing (AuthInfo)



errorText : Maybe String -> Html msg
errorText msg =
    case msg of
        Nothing ->
            text ""
        Just msg ->
            text msg



view : AuthInfo -> Html Msg
view model =
    div []
        [ input
            [ type' "text"
            , placeholder "Username"
            , value model.username
            , onInput EnterUsername
            ] []
        , br [] []
        , input
            [ type' "password"
            , placeholder "Password"
            , value model.password
            , onInput EnterPassword
            ] []
        , br [] []
        , button [ onClick PressLoginButton ] [ text "Login" ]
        , p [] [ errorText model.errorMessage ]
        ]
