module Auth.LoginView exposing (..)

import Html exposing (Html, div, input, br, button, text)
import Html.Attributes exposing (type', placeholder, value, class, attribute)
import Html.Events exposing (onInput, onClick)
import Auth.Messages exposing (..)
import Auth.Models exposing (AuthInfo)


view : AuthInfo -> Html Msg
view model =
    let
        errorMessage =
            case model.errorMessage of
                Just msg ->
                    div
                        [ class "alert alert-danger"
                        , attribute "role" "alert"
                        ]
                        [ text msg ]

                Nothing ->
                    div [] []
    in
        div [ class "container" ]
            [ input
                [ type' "text"
                , class "form-control"
                , placeholder "Username"
                , value model.username
                , onInput EnterUsername
                ]
                []
            , br [] []
            , input
                [ type' "password"
                , class "form-control"
                , placeholder "Password"
                , value model.password
                , onInput EnterPassword
                ]
                []
            , br [] []
            , button
                [ class "btn btn-default"
                , onClick PressLoginButton
                ]
                [ text "Login" ]
            , errorMessage
            ]
