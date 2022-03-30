module Ellies.Step02 exposing (main)

import Expect
import Fuzz
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Random
import Test
import Test.Html.Query
import Test.Html.Selector
import Test.Runner.Html


resultPage : Int -> Html msg
resultPage score =
    div []
        [ text "Content should go here"
        ]



------------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only displays the result of your code and the result of the tests --
------------------------------------------------------------------------------------------------------------------------


homePage : Html msg
homePage =
    resultPage 3


main : Html a
main =
    Html.div []
        [ testStyles
        , div [ class "jumbotron" ] [ homePage ]
        , div [] [ Html.a [ Html.Attributes.target "_blank", Html.Attributes.href "https://github.com/lucamug/elm-workshop/blob/master/Step02/README.md" ] [ text "Step 2 - Objective" ] ]
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
        , scoreIsPresent
        , replayLinkIsPresent
        , replayLinkShouldHaveProperClasses
        , replayLinkGoToHome
        ]


divHasProperClassTest : Test.Test
divHasProperClassTest =
    Test.test "The div should have a class 'score'" <|
        \() ->
            div [] [ resultPage 3 ]
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "div" ]
                |> Test.Html.Query.has [ Test.Html.Selector.class "score" ]


titleIsPresent : Test.Test
titleIsPresent =
    Test.test "'Your score' is displayed into a h1 tag" <|
        \() ->
            resultPage 3
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "h1" ]
                |> Test.Html.Query.has [ Test.Html.Selector.text "Your score" ]


scoreIsPresent : Test.Test
scoreIsPresent =
    Test.fuzz (Fuzz.intRange 0 5) "The proper score is displayed inside the h1 tag" <|
        \randomScore ->
            resultPage randomScore
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "h1" ]
                |> Test.Html.Query.has [ Test.Html.Selector.text (String.fromInt randomScore) ]


replayLinkIsPresent : Test.Test
replayLinkIsPresent =
    Test.test "There is a link with the text 'Replay'" <|
        \() ->
            resultPage 3
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.has [ Test.Html.Selector.text "Replay" ]


replayLinkShouldHaveProperClasses : Test.Test
replayLinkShouldHaveProperClasses =
    Test.test "The replay link should have classes 'btn btn-primary'" <|
        \() ->
            resultPage 3
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.has [ Test.Html.Selector.classes [ "btn", "btn-primary" ] ]


replayLinkGoToHome : Test.Test
replayLinkGoToHome =
    Test.test "The replay link should go to '#'" <|
        \() ->
            resultPage 3
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.has [ Test.Html.Selector.attribute (Html.Attributes.href "#") ]
