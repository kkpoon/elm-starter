module Auth.Models exposing (..)



type alias Token =
    String



type alias AuthInfo =
    { username : String
    , password : String
    , token : Token
    , errorMessage : String
    , authenticated : Bool
    }



newAuthInfo : AuthInfo
newAuthInfo =
    { username = ""
    , password = ""
    , token = ""
    , errorMessage = ""
    , authenticated = False
    }
