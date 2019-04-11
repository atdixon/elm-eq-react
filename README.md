# elm-eq-react

Exploring the differences and similarities between React and Elm.

A simplistic "Grocery List" app is implemented in various ways to demonstrate
the differences between these two language/frameworks.

The app is contrived to be as simple as possible while exercising a few
 basic essential use cases: rendering, user events, async http, and even
 keyboard handling.

#### Run

    $ yarn start
    
This starts a webpack-dev-server that will hot-reload React and Elm 
code changes. (The React and Elm versions of the App are styled to be
 side-by-side.)

#### Notes

`src/index.js` imports a specific example. You'll need to edit this file to 
import the different examples, then re-run `yarn start`.

* `src/minimal-diff/App.{jsx|elm}`
    - Implements the app keeping a minimal diff between the two implementations.
* `src/idiomatic/App.{jsx|elm}` 
    - Implements the app adhering to idioms of each language/framework.
* `src/componentized/App.{jsx|elm}`
    - What a component with private information looks like in each framework.
* `src/with-keyboard/App.{jsx|elm}`
    - Supports a basic keyboard command (shift-click) use case. The interesting point here is how
    React handles referencing an invalid value from an Event vs. Elm's choice.