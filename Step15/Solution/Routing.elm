module Step15.Solution.Routing exposing (parseLocation)

import Step15.Solution.Types exposing (RemoteData(..))
import Url
import Url.Parser as Parser exposing (..)



-- matcher : Parser (Route -> a) a
-- matcher =
--     oneOf
--         [ map HomepageRoute top
--         , map CategoriesRoute (s "categories")
--         , map ResultRoute (s "result" </> int)
--         , map (GameRoute Loading) (s "game")
--


routeParser : Parser.Parser (Step15.Solution.Types.Route -> Step15.Solution.Types.Route) Step15.Solution.Types.Route
routeParser =
    Parser.oneOf
        [ Parser.map Step15.Solution.Types.HomepageRoute Parser.top
        , Parser.map Step15.Solution.Types.CategoriesRoute (Parser.s "categories")
        , Parser.map Step15.Solution.Types.ResultRoute (Parser.s "result" </> Parser.int)
        , Parser.map (Step15.Solution.Types.GameRoute Loading) (Parser.s "game")
        ]


parseLocation : Url.Url -> Step15.Solution.Types.Route
parseLocation url =
    let
        newUrl =
            { url
                | path =
                    case url.fragment of
                        Nothing ->
                            ""

                        Just fragment ->
                            "/" ++ fragment
            }
    in
    Parser.parse routeParser newUrl
        |> Maybe.withDefault Step15.Solution.Types.HomepageRoute
