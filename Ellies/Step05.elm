module Ellies.Step05 exposing (main)

import Expect
import Fuzz
import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (class, href, style)
import Random
import Test
import Test.Html.Query
import Test.Html.Selector
import Test.Runner.Html


type alias Category =
    { id : Int
    , name : String
    }


categoriesPage : Html msg
categoriesPage =
    div []
        [ text "Content of the page" ]


categories : List Category
categories =
    [ { id = 9, name = "General Knowledge" }
    , { id = 10, name = "Entertainment: Books" }
    , { id = 11, name = "Entertainment: Film" }
    , { id = 12, name = "Entertainment: Music" }
    , { id = 13, name = "Entertainment: Musicals & Theatres" }
    , { id = 14, name = "Entertainment: Television" }
    , { id = 15, name = "Entertainment: Video Games" }
    , { id = 16, name = "Entertainment: Board Games" }
    , { id = 17, name = "Science & Nature" }
    , { id = 18, name = "Science: Computers" }
    , { id = 19, name = "Science: Mathematics" }
    , { id = 20, name = "Mythology" }
    , { id = 21, name = "Sports" }
    , { id = 22, name = "Geography" }
    , { id = 23, name = "History" }
    , { id = 24, name = "Politics" }
    , { id = 25, name = "Art" }
    , { id = 26, name = "Celebrities" }
    , { id = 27, name = "Animals" }
    , { id = 28, name = "Vehicles" }
    , { id = 29, name = "Entertainment: Comics" }
    , { id = 30, name = "Science: Gadgets" }
    , { id = 31, name = "Entertainment: Japanese Anime & Manga" }
    , { id = 32, name = "Entertainment: Cartoon & Animations" }
    ]



------------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only displays the result of your code and the result of the tests --
------------------------------------------------------------------------------------------------------------------------


homePage : Html msg
homePage =
    categoriesPage


main : Html a
main =
    Html.div []
        [ testStyles
        , div [ class "jumbotron" ] [ homePage ]
        , div [] [ Html.a [ Html.Attributes.target "_blank", Html.Attributes.href "https://github.com/lucamug/elm-workshop/blob/master/Step05/README.md" ] [ text "Step 5 - Objective" ] ]
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
        [ titleIsPresentWithProperText
        , listOfCategoriesIsPresent
        , everyCategoriesAreDisplayed
        , eachCategoryHasItsNameDisplayed
        , replayLinkShouldHaveProperClasses
        , replayLinkShouldHaveProperLink
        ]


titleIsPresentWithProperText : Test.Test
titleIsPresentWithProperText =
    Test.test "There should be a title with the proper text \"Play within a given category\"" <|
        \() ->
            categoriesPage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "h1" ]
                |> Test.Html.Query.has [ Test.Html.Selector.text "Play within a given category" ]


listOfCategoriesIsPresent : Test.Test
listOfCategoriesIsPresent =
    Test.test "There should be an 'ul' Test.Html.Selector.tag with the class \"categories\"" <|
        \() ->
            categoriesPage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.find [ Test.Html.Selector.tag "ul" ]
                |> Test.Html.Query.has [ Test.Html.Selector.class "categories" ]


everyCategoriesAreDisplayed : Test.Test
everyCategoriesAreDisplayed =
    Test.test "There are 24 'li' tags displayed, one for each category" <|
        \() ->
            categoriesPage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.findAll [ Test.Html.Selector.tag "li" ]
                |> Test.Html.Query.count (Expect.equal 24)


eachCategoryHasItsNameDisplayed : Test.Test
eachCategoryHasItsNameDisplayed =
    Test.fuzz (Fuzz.intRange 0 23) "Each category has its name displayed" <|
        \categoryIndex ->
            case getCategory categoryIndex of
                Just category ->
                    categoriesPage
                        |> Test.Html.Query.fromHtml
                        |> Test.Html.Query.has [ Test.Html.Selector.text category.name ]

                Nothing ->
                    "Cannot find category with index "
                        ++ String.fromInt categoryIndex
                        ++ ", have you touched the categories list?"
                        |> Expect.fail


replayLinkShouldHaveProperClasses : Test.Test
replayLinkShouldHaveProperClasses =
    Test.test "Each link has the classes \"btn btn-primary\"" <|
        \() ->
            categoriesPage
                |> Test.Html.Query.fromHtml
                |> Test.Html.Query.findAll [ Test.Html.Selector.tag "a" ]
                |> Test.Html.Query.each (Test.Html.Query.has [ Test.Html.Selector.classes [ "btn", "btn-primary" ] ])


replayLinkShouldHaveProperLink : Test.Test
replayLinkShouldHaveProperLink =
    Test.fuzz (Fuzz.intRange 0 23) "Each category have the proper link" <|
        \categoryIndex ->
            let
                linkMaybe =
                    getCategory categoryIndex
                        |> Maybe.map
                            (.id
                                >> String.fromInt
                                >> (++) "#game/category/"
                            )
            in
            case linkMaybe of
                Just link ->
                    categoriesPage
                        |> Test.Html.Query.fromHtml
                        |> Test.Html.Query.has [ Test.Html.Selector.tag "a", Test.Html.Selector.attribute (Html.Attributes.href link) ]

                Nothing ->
                    "Cannot find category with index "
                        ++ String.fromInt categoryIndex
                        ++ ", have you touched the categories list?"
                        |> Expect.fail


getCategory : Int -> Maybe Category
getCategory index =
    categories
        |> List.drop index
        |> List.head
