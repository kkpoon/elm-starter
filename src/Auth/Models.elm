module Auth.Models exposing (..)


type alias Token =
    String


type alias AuthInfo =
    { username : String
    , password : String
    , token : Maybe Token
    , errorMessage : Maybe String
    , authenticated : Bool
    }


newAuthInfo : AuthInfo
newAuthInfo =
    { username = ""
    , password = ""
    , token = Nothing
    , errorMessage = Nothing
    , authenticated = False
    }
