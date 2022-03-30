module Step15.Solution.Types exposing (AnsweredQuestion, Category, Game, Model, Msg(..), Question, QuestionStatus(..), RemoteData(..), Route(..))

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation exposing (Key)
import Http exposing (Error)
import Url exposing (Url)


type alias Model =
    { categories : RemoteData (List Category)
    , route : Route
    , key : Key
    }


type Msg
    = OnCategoriesFetched (Result Error (List Category))
    | OnQuestionsFetched (Result Error (List Question))
    | AnswerQuestion String
    | OnUrlRequest UrlRequest
    | OnUrlChange Url


type alias Category =
    { id : Int, name : String }


type RemoteData a
    = Loading
    | Loaded a
    | OnError


type alias Question =
    { question : String
    , correctAnswer : String
    , answers : List String
    }


type alias AnsweredQuestion =
    { question : Question
    , status : QuestionStatus
    }


type QuestionStatus
    = Correct
    | Incorrect


type alias Game =
    { answeredQuestions : List AnsweredQuestion
    , currentQuestion : Question
    , remainingQuestions : List Question
    }


type Route
    = HomepageRoute
    | CategoriesRoute
    | ResultRoute Int
    | GameRoute (RemoteData Game)
