module Ellies.Step01 exposing (main)

import Expect
import Html exposing (Html, a, div, h1, text)
import Html.Attributes exposing (class, href)
import Random
import Test
import Test.Html.Query
import Test.Html.Selector
import Test.Runner.Html


homePage : Html msg
homePage =
    div []
        [ h1 [] [ text "A random title" ]
        , a [ class "btn", href "#nowhere" ] [ text "A random link" ]
        ]



------------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only displays the result of your code and the result of the tests --
------------------------------------------------------------------------------------------------------------------------


main : Html a
main =
    Html.div []
        [ testStyles
        , div [ class "jumbotron" ] [ homePage ]
        , div [] [ a [ Html.Attributes.target "_blank", href "https://github.com/lucamug/elm-workshop/blob/master/Step01/README.md" ] [ text "Step 1 - Objective" ] ]
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


suite : Test.Test
suite =
    Test.concat
        [ divHasProperClassTest
        , titleIsPresent
        , twoLinksAreDisplayed
        , theTwoLinksHaveProperClasses
        , aLinkToGameIsPresent
        , theGameLinkHasProperText
        , aLinkToCategoriesIsPresent
        , theCategoriesLinkHasProperText
        ]


divHasProperClassTest : Test.Test
divHasProperClassTest =
    Test.test "The div should have a class 'gameOptions'" <|
        \() ->
            Html.div [] [ homePage ]
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "div" ]
                |> Test.Html.Query.has [ Test.Html.Selector.class "gameOptions" ]


titleIsPresent : Test.Test
titleIsPresent =
    Test.test "There should be a h1 tag containing the text 'Quiz Game' (watch out, the case is important!)" <|
        \() ->
            homePage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "h1" ]
                |> Test.Html.Query.has [ Test.Html.Selector.text "Quiz Game" ]


twoLinksAreDisplayed : Test.Test
twoLinksAreDisplayed =
    Test.test "Two links are displayed" <|
        \() ->
            homePage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.findAll [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.count (Expect.equal 2)


theTwoLinksHaveProperClasses : Test.Test
theTwoLinksHaveProperClasses =
    Test.test "The two links have the classes 'btn btn-primary'" <|
        \() ->
            homePage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.findAll [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.each (Test.Html.Query.has [ Test.Html.Selector.classes [ "btn", "btn-primary" ] ])


aLinkToGameIsPresent : Test.Test
aLinkToGameIsPresent =
    Test.test "The first link goes to '#game'" <|
        \() ->
            homePage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.findAll [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.first
                |> Test.Html.Query.has [ Test.Html.Selector.attribute (href "#game") ]


theGameLinkHasProperText : Test.Test
theGameLinkHasProperText =
    Test.test "The first link has text 'Play random questions'" <|
        \() ->
            homePage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.findAll [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.first
                |> Test.Html.Query.has [ Test.Html.Selector.text "Play random questions" ]


aLinkToCategoriesIsPresent : Test.Test
aLinkToCategoriesIsPresent =
    Test.test "The second link goes to '#categories'" <|
        \() ->
            homePage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.findAll [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.index 1
                |> Test.Html.Query.has [ Test.Html.Selector.attribute (href "#categories") ]


theCategoriesLinkHasProperText : Test.Test
theCategoriesLinkHasProperText =
    Test.test "The second link has text 'Play from a category'" <|
        \() ->
            homePage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.findAll [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.index 1
                |> Test.Html.Query.has [ Test.Html.Selector.text "Play from a category" ]
