defmodule Mix.Tasks.PhoenixReactor.Install do
  use Mix.Task

  @shortdoc "Install react, babel and webpack"

  @moduledoc """
  Installs react, babel and webpack.

  ## Example

      mix phoenix_reactor.install
  ## Command line options

    * `--no-webpack` - omit installing babel and webpack

  During installation few files are generated (unless they already exist).
  ## Example of generated files:

      ./.babelrc
      ./packages.json
      ./webpack.config.js
      ./web/static/js/app.js
      ./web/static/js/phoenix_reactor.js
  """

  def run(opts) do
    init_npm()
    install_react()
    unless Enum.member?(opts, "--no-webpack"), do: install_webpack()
  end

  @priv_source_dir "./_build/dev/lib/phoenix_reactor/priv"

  defp init_npm do
    unless File.exists?("./package.json") do
      "npm init --yes" |> cmd
    end
  end

  @react_packages [
    "react",
    "react-dom"
  ]

  @web_js_directory "./web/static/js"

  defp install_react do
    Enum.join(["npm install"] ++ @react_packages ++ ["--save"], " ") |> cmd

    File.mkdir_p! @web_js_directory

    copy_if_not_exists Path.join(@priv_source_dir, "phoenix_reactor.js"),
      Path.join(@web_js_directory, "phoenix_reactor.js")

    copy_if_not_exists Path.join(@priv_source_dir, "app.js"),
      Path.join(@web_js_directory, "app.js")
  end

  @webpack_packages [
    "babel-core",
    "babel-loader",
    "babel-preset-es2015",
    "babel-preset-react",
    "webpack",
    "webpack-dev-server"
  ]

  defp install_webpack do
    Enum.join(["npm install"] ++ @webpack_packages ++ ["--save-dev"], " ") |> cmd

    copy_if_not_exists Path.join(@priv_source_dir, "webpack.config.js"), "./webpack.config.js"
    copy_if_not_exists Path.join(@priv_source_dir, "babelrc"), "./.babelrc"
    move_if_not_exists "./priv/static/js/phoenix.js", Path.join(@web_js_directory, "phoenix.js")

    IO.puts "\nRemember to add following to ./config/dev.exs\n
      watchers: [node: [\"node_modules/webpack/bin/webpack.js\", \"--watch\", \"--color\"]]"
  end

  defp cmd(cmd) do
    Mix.shell.info [:green, "* running ", :reset, cmd]
    Mix.shell.cmd(cmd)
  end

  defp copy_if_not_exists(source, destination) do
    unless File.exists? destination do
      Mix.shell.info [:green, "* creating ", :reset, destination]
      File.cp! source, destination
    else
      Mix.shell.info [:yellow, "* skipping (file already exists) ", :reset, destination]
    end
  end

  defp move_if_not_exists(source, destination) do
    if File.exists?(source) && !File.exists?(destination) do
      Mix.shell.info [:green, "* moving ", :reset, source, " to ", destination]
      File.cp! source, destination
      File.rm! source
    end
  end
end
