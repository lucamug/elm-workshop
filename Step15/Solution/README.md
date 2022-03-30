# Solution

The main changes are:

  - In the `View.elm` file, we added an `onClick` on the responses
  - In `Types.elm` we have therefore added the corresponding `AnswerQuestion` event
  - In `Update.elm` we process this new event; this is the biggest change, take the time to look at it to understand everything!
