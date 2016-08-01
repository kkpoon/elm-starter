module Routing exposing
    ( Route(..)
    , Model
    , parser
    , nextRoute
    , goto
    , replaceWith
    )

import String
import Navigation
import UrlParser exposing (..)
import Auth.Models exposing (AuthInfo)



type Route
    = IndexRoute
    | LoginRoute
    | MemberAreaRoute
    | UnauthorizedRoute
    | NotFoundRoute



type alias Model =
    { authInfo : AuthInfo
    }



routeToHashUrl : Route -> String
routeToHashUrl route =
    case route of
        IndexRoute ->
            "/#"
        LoginRoute ->
            "/#login"
        MemberAreaRoute ->
            "/#member"
        UnauthorizedRoute ->
            "/#403"
        NotFoundRoute ->
            "/#404"



matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ format IndexRoute (s "")
        , format LoginRoute (s "login")
        , format MemberAreaRoute (s "member")
        ]



hashParser : Navigation.Location -> Result String Route
hashParser location =
    location.hash
        |> String.dropLeft 1
        |> parse identity matchers



parser : Navigation.Parser (Result String Route)
parser =
    Navigation.makeParser hashParser



nextRoute : Result String Route -> Model -> Result (Cmd a) Route
nextRoute result model =
    let
        authenticated =
            model.authInfo.authenticated
    in
        case Debug.log "Route" result of
            Ok route ->
                if route == MemberAreaRoute && not authenticated then
                    Err (replaceWith LoginRoute)
                else
                    Ok route
            Err string ->
                Ok NotFoundRoute



goto : Route -> Cmd a
goto route =
    Navigation.newUrl (routeToHashUrl route)



replaceWith : Route -> Cmd a
replaceWith route =
    Navigation.modifyUrl (routeToHashUrl route)
