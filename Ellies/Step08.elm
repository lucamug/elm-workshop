module Ellies.Step08 exposing (main)

import Browser
import Expect
import Fuzz
import Html exposing (Html, div, h1, input, label, p, text)
import Html.Attributes exposing (class, for, id, name, type_)
import Html.Events exposing (onClick)
import Http exposing (expectString)
import Random
import Result exposing (Result)
import Test
import Test.Html.Event
import Test.Html.Query
import Test.Html.Selector
import Test.Runner.Html
import TestContext


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , update = update
        , view = displayTestsAndView
        , subscriptions = \model -> Sub.none
        }


type alias Model =
    { categories : RemoteData String }


type Msg
    = OnCategoriesFetched (Result Http.Error String)


type alias Category =
    { id : Int
    , name : String
    }


type RemoteData a
    = Loading
    | Loaded a
    | OnError


init : ( Model, Cmd Msg )
init =
    ( Model Loading, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Play within a given category" ]
        , text "Loading the categories..."
        ]



------------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only displays the result of your code and the result of the tests --
------------------------------------------------------------------------------------------------------------------------


displayTestsAndView : Model -> Html Msg
displayTestsAndView model =
    div []
        [ view model
        , displayTestsAndStyle
        ]


displayTestsAndStyle : Html a
displayTestsAndStyle =
    Html.div []
        [ testStyles
        , div [] [ Html.a [ Html.Attributes.target "_blank", Html.Attributes.href "https://github.com/lucamug/elm-workshop/blob/master/Step08/README.md" ] [ text "Step 8 - Objective" ] ]
        , div [ Html.Attributes.id "tests" ]
            [ Test.Runner.Html.viewResults (Random.initialSeed 1000 |> Test.Runner.Html.defaultConfig |> Test.Runner.Html.hidePassedTests) suite
            ]
        ]


testStyles : Html a
testStyles =
    Html.div []
        [ Html.node "link"
            [ Html.Attributes.rel "stylesheet"
            , Html.Attributes.href "https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css"
            ]
            []
        , Html.node "style"
            []
            [ Html.text """

body {
    text-align: center;
}

h1 {
    margin-bottom: 5vh;
}

.gameOptions {
    text-align: center;
}

.gameOptions a {
    display: block;
    max-width: 300px;
    margin: 1em auto 0;
}

.score {
    text-align: center;
}

.categories {
    display: grid;
    grid-template-columns: repeat(auto-fit, 366px);
    grid-template-columns: repeat(auto-fit, minmax(366px, 1fr));
    grid-gap: 20px;
    padding: 0;
    margin: auto;
    text-align: center;
    list-style-type: none;
}

.categories a {
    width: 100%;
    height: 100%;
}

.question {
    text-align: center;
    margin: auto auto 3em;
}

.answers {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-gap: 20px;
    max-width: 70%;
    padding: 0;
    margin: auto;
    text-align: center;
    list-style-type: none;
}

.answers a.btn {
    color: white;
}

/*Trick to avoid elm-reactor errors to be centered, which is really not readable...*/
div [style="display: block; white-space: pre; background-color: rgb(39, 40, 34); padding: 2em;"] {
    text-align: left;
}










.test-pass {
    color: #1e7e34;
    margin-bottom: 20px;
}

.test-fail {
    color: red;
    margin-bottom: 20px;
}

.test-fail pre {
    color: red;
}

#tests {
    text-align: left;
    height: 400px;
    overflow: auto;
    border: 1px solid gray;
    margin: 20px;
    padding: 20px;
    
}""" ]
        ]


categoriesUrl : String
categoriesUrl =
    "https://opentdb.com/api_category.php"


categoriesPageProgram : TestContext.TestContext Msg Model (Cmd Msg)
categoriesPageProgram =
    TestContext.createWithSimulatedEffects
        { init = init
        , update = update
        , view = view
        , deconstructEffect = \_ -> [ TestContext.HttpRequest { method = "get", url = categoriesUrl } ]
        }


suite : Test.Test
suite =
    Test.concat
        [ theInitMethodShouldFetchCategories
        , theInitModelShouldBeLoading
        , whenTheCategoriesAreLoadingAMessageShouldSaySo
        , whenInitRequestFailTheCategoriesShouldBeOnError
        , whenInitRequestFailThereShouldBeAnError
        , whenInitRequestCompletesTheModelShouldBeUpdated
        , whenInitRequestCompletesTheResultShouldBeDisplayed
        ]


theInitMethodShouldFetchCategories : Test.Test
theInitMethodShouldFetchCategories =
    Test.test "The init method should return a `Cmd` (ideally to fetch categories, but this is not covered by this test)." <|
        \() ->
            Expect.false "The init method should return a Cmd" (Tuple.second init == Cmd.none)


theInitModelShouldBeLoading : Test.Test
theInitModelShouldBeLoading =
    Test.test "The init model should indicates that the categories are loading" <|
        \() ->
            Expect.equal (Model Loading) (Tuple.first init)


whenTheCategoriesAreLoadingAMessageShouldSaySo : Test.Test
whenTheCategoriesAreLoadingAMessageShouldSaySo =
    Test.test "When the request is loading, the following message should be displayed: \"Loading the categories...\"" <|
        \() ->
            categoriesPageProgram
                |> TestContext.expectViewHas [ Test.Html.Selector.containing [ Test.Html.Selector.text "Loading the categories..." ] ]


whenInitRequestFailTheCategoriesShouldBeOnError : Test.Test
whenInitRequestFailTheCategoriesShouldBeOnError =
    Test.test "When the request fails, the model should keep track of that and there should be no command sent" <|
        \() ->
            let
                model =
                    update (OnCategoriesFetched (Err Http.NetworkError)) (Model Loading)
            in
            Expect.equal ( Model OnError, Cmd.none ) model


whenInitRequestFailThereShouldBeAnError : Test.Test
whenInitRequestFailThereShouldBeAnError =
    Test.test "When the request fails, the following error message should be displayed: \"An error occurred while loading the categories\"" <|
        \() ->
            categoriesPageProgram
                |> TestContext.update (OnCategoriesFetched (Err Http.NetworkError))
                |> TestContext.expectViewHas [ Test.Html.Selector.containing [ Test.Html.Selector.text "An error occurred while loading the categories" ] ]


whenInitRequestCompletesTheModelShouldBeUpdated : Test.Test
whenInitRequestCompletesTheModelShouldBeUpdated =
    Test.fuzz Fuzz.string "When the request completes, the model should store the string returned and there should be no command sent" <|
        \randomResponse ->
            let
                model =
                    update (OnCategoriesFetched (Ok randomResponse)) (Model Loading)
            in
            Expect.equal ( Model (Loaded randomResponse), Cmd.none ) model


whenInitRequestCompletesTheResultShouldBeDisplayed : Test.Test
whenInitRequestCompletesTheResultShouldBeDisplayed =
    Test.fuzz Fuzz.string "When the request completes, the resulting string should be displayed" <|
        \randomResponse ->
            categoriesPageProgram
                |> TestContext.update (OnCategoriesFetched (Ok randomResponse))
                |> TestContext.expectViewHas [ Test.Html.Selector.containing [ Test.Html.Selector.text randomResponse ] ]
