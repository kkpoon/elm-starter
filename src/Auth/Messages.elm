module Auth.Messages exposing (..)



type Msg
    = EnterUsername String
    | EnterPassword String
    | PressLoginButton
    | LoginSuccess String String
    | LoginFail String
