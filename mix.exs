defmodule PhoenixReactor.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_reactor,
     version: "0.0.2",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     description: description]
  end

  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [{:phoenix_html, "~> 2.5"},
    {:poison, "~> 1.5.2"},
    {:ex_doc, "~> 0.11.5", only: :dev},
    {:earmark, "~> 0.2.1", only: :dev}]
  end

  defp package do
    [contributors: ["Jacek Adamek"],
    licenses: ["MIT"],
    links: %{ "Github" => "https://github.com/jacek-adamek/phoenix_reactor" }]
  end

  defp description do
    """
    Library which provides an easy way to use React and Phoenix framework.
    """
  end
end
