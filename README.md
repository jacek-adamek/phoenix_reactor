# PhoenixReactor

Library which main aim is to provide an easy way to use [React](https://facebook.github.io/react/) with [Phoenix](http://www.phoenixframework.org/) framework.

## Installation

1. Add phoenix_reactor to your list of dependencies in `mix.exs`:

        def deps do
          [{:phoenix_reactor, "~> 0.0.2"}]
        end

2. Get dependency:

        mix deps.get

3. Compile your phoenix project:

        mix compile

BTW: It is assumed that you have created your phoenix project with `--no-brunch` option i.e.

        mix phoenix.new --no-brunch hello_phoenix

## Tasks

After compiling your Phoenix application you will get new mix task at your disposal:

        mix phoenix_reactor.install

Above task will install a bunch of new files (providing that they do not exist):

        ./.babelrc
        ./packages.json
        ./webpack.config.js
        ./web/static/js/app.js
        ./web/static/js/phoenix_reactor.js

and call npm to install dependencies.


If you want to skip babel and webpack installation run above task with `--no-webpack` option:

        mix phoenix_reactor.install --no-webpack

After installation, remember to add following watcher definition:

        watchers: [node: ["node_modules/webpack/bin/webpack.js", "--watch", "--color"]]

to your `./config/dev.exs` file

## Usage

PhoenixReactor gives you a convinient `PhoenixReactor.react_container` function which allows you to render react components. You can use it in templates or view modules.

1. In a template file:

        <%# show.html.eex %>
        ...
        <p>
          <%= PhoenixReactor.react_container "hello", %{name: @name} %>
        </p>
        ...

2. In a view module (replacing the whole template with a react component):

        # home_view.ex
        def render("show.html", assigns) do
          PhoenixReactor.react_container "hello", %{name: assigns[:name]}
        end


Before you will be able to use any react component you must export it. To do that in your app.js file call `exportComponent` function defined in the `phoenix_reactor` module. For example:

        // app.js
        import {exportComponent} from "./phoenix_reactor"
        import Hello from "./components/hello"

        exportComponent("hello", Hello)

In that case component `Hello` will be visible for `PhoenixReactor.react_container` under the name of `hello` (or whichever other name you wish).

To have the whole picture the `Hello` component could look like following:

        // components/hello.js
        import React from "react"

        export default ({name}) => {
          return (
            <div>
              <h1>Hello, {name}!</h1>
            </div>
          )
        }

