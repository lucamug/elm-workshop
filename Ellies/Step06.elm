module Ellies.Step06 exposing (main)

import Browser
import Expect
import Fuzz
import Html exposing (Html, div, input, label, p, text)
import Html.Attributes exposing (class, for, id, name, type_)
import Html.Events exposing (onClick)
import Random
import Test
import Test.Html.Event
import Test.Html.Query
import Test.Html.Selector
import Test.Runner.Html


{-| This line creates a program with everything it needs (see the README)
You don't need to modify it.
-}
main : Program () UserStatus Msg
main =
    Browser.sandbox { init = initialModel, view = displayTestsAndView, update = update }


{-| Modify this union type to fit our needs.
It should contain three values: NotSpecified, UnderAge and Adult.
-}
type UserStatus
    = ModifyThisType


{-| Don't modify this union type, it already contains the only message we need.
-}
type Msg
    = UserStatusSelected UserStatus


{-| Once the type UserStatus is fixed, you'll be able to initialize properly the model here.
-}
initialModel : UserStatus
initialModel =
    ModifyThisType


{-| Don't modify this function, it displays everything you need and also displays the tests.
-}
view : UserStatus -> Html Msg
view userStatus =
    div []
        [ div [ class "jumbotron" ]
            [ userStatusForm
            , p [] [ statusMessage userStatus ]
            ]
        ]


{-| You will need to modify the messages sent by those inputs.
You can see how `onClick` is used to send a message `UserStatusSelected` with a value of `ModifyThisType`.
Once you have changed the UserStatus type, you can change the messages here
-}
userStatusForm : Html Msg
userStatusForm =
    div [ class "mb-3" ]
        [ input
            [ id "underage"
            , name "status"
            , type_ "radio"
            , onClick (UserStatusSelected ModifyThisType)
            ]
            [ text "I'm underage" ]
        , label [ class "mr-3", for "underage" ] [ text "I'm underage" ]
        , input
            [ id "adult"
            , name "status"
            , type_ "radio"
            , onClick (UserStatusSelected ModifyThisType)
            ]
            [ text "I'm an adult!" ]
        , label [ for "adult" ] [ text "I'm an adult" ]
        ]


{-| Customize this message according to the user status. If the status is not specified, just return an empty text.
-}
statusMessage : UserStatus -> Html Msg
statusMessage userStatus =
    case userStatus of
        ModifyThisType ->
            text "Personalize the message according to the user status"


{-| Update the model according to the message received
-}
update : Msg -> UserStatus -> UserStatus
update message userStatus =
    case message of
        UserStatusSelected newUserStatus ->
            userStatus



------------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only displays the result of your code and the result of the tests --
------------------------------------------------------------------------------------------------------------------------


displayTestsAndView : UserStatus -> Html Msg
displayTestsAndView userStatus =
    div []
        [ view userStatus
        , displayTestsAndStyle
        ]


displayTestsAndStyle : Html a
displayTestsAndStyle =
    Html.div []
        [ testStyles
        , div [] [ Html.a [ Html.Attributes.target "_blank", Html.Attributes.href "https://github.com/lucamug/elm-workshop/blob/master/Step06/README.md" ] [ text "Step 6 - Objective" ] ]
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
        [ atFirstThereShouldBeNoMessage
        , whenFirstRadioButtonIsClickedUserShouldBeUnderage
        , whenSecondRadioButtonIsClickedUserShouldBeAdult
        ]


atFirstThereShouldBeNoMessage : Test.Test
atFirstThereShouldBeNoMessage =
    Test.test "At first there should be no message displayed" <|
        \() ->
            Expect.all
                [ Test.Html.Query.hasNot [ Test.Html.Selector.text "You are underage" ]
                , Test.Html.Query.hasNot [ Test.Html.Selector.text "You are an adult" ]
                ]
                (view initialModel |> Test.Html.Query.fromHtml)


whenFirstRadioButtonIsClickedUserShouldBeUnderage : Test.Test
whenFirstRadioButtonIsClickedUserShouldBeUnderage =
    Test.test "When we click on the first radio button, a message \"You are underage\" should appear" <|
        \() ->
            let
                messageTriggered =
                    view initialModel
                        |> Test.Html.Query.fromHtml
                        |> Test.Html.Query.findAll [ Test.Html.Selector.attribute (type_ "radio") ]
                        |> Test.Html.Query.first
                        |> Test.Html.Event.simulate Test.Html.Event.click
                        |> Test.Html.Event.toResult

                updatedModel =
                    messageTriggered
                        |> Result.map (\msg -> update msg initialModel)

                updatedView =
                    updatedModel
                        |> Result.map (\model -> view model)
                        |> Result.map Test.Html.Query.fromHtml
            in
            Expect.all
                [ \result ->
                    result
                        |> Result.map (Test.Html.Query.has [ Test.Html.Selector.text "You are underage" ])
                        |> Result.withDefault (Expect.fail "\"You are underage\" should be present")
                , \result ->
                    Result.map (Test.Html.Query.hasNot [ Test.Html.Selector.text "You are an adult" ]) result
                        |> Result.withDefault (Expect.fail "\"You are an adult\" should not be present")
                ]
                updatedView


whenSecondRadioButtonIsClickedUserShouldBeAdult : Test.Test
whenSecondRadioButtonIsClickedUserShouldBeAdult =
    Test.test "When we click on the second radio button, a message \"You are an adult\" should appear" <|
        \() ->
            let
                messageTriggered =
                    view initialModel
                        |> Test.Html.Query.fromHtml
                        |> Test.Html.Query.findAll [ Test.Html.Selector.attribute (type_ "radio") ]
                        |> Test.Html.Query.index 1
                        |> Test.Html.Event.simulate Test.Html.Event.click
                        |> Test.Html.Event.toResult

                updatedModel =
                    messageTriggered
                        |> Result.map (\msg -> update msg initialModel)

                updatedView =
                    updatedModel
                        |> Result.map (\model -> view model)
                        |> Result.map Test.Html.Query.fromHtml
            in
            Expect.all
                [ \result ->
                    Result.map (Test.Html.Query.hasNot [ Test.Html.Selector.text "You are underage" ]) result
                        |> Result.withDefault (Expect.fail "\"You are underage\" should not be present")
                , \result ->
                    Result.map (Test.Html.Query.has [ Test.Html.Selector.text "You are an adult" ]) result
                        |> Result.withDefault (Expect.fail "\"You are an adult\" should be present")
                ]
                updatedView
