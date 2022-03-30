module Step15.Solution.Main exposing (init, main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation exposing (Key)
import Step15.Solution.Api exposing (getCategoriesCommand, getQuestionsCommand)
import Step15.Solution.Routing exposing (parseLocation)
import Step15.Solution.Types exposing (Model, Msg(..), RemoteData(..), Route(..))
import Step15.Solution.Update exposing (update)
import Step15.Solution.View exposing (displayTestsAndView)
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view =
            \model ->
                { title = "elm-workshop"
                , body = displayTestsAndView model
                }
        , subscriptions = always Sub.none
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }


init : () -> Url.Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    let
        route =
            parseLocation url

        initialModel =
            Model Loading route key

        initialCommand =
            case route of
                GameRoute _ ->
                    Cmd.batch [ getCategoriesCommand, getQuestionsCommand ]

                _ ->
                    getCategoriesCommand
    in
    ( initialModel, initialCommand )
