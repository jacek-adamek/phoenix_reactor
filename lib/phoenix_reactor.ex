defmodule PhoenixReactor do

  @moduledoc """
  Module contains a function which helps to render react component.
  """

  import Phoenix.HTML.Tag, only: [content_tag: 3]

  @data_react_component "react-component"
  @data_react_props "react-props"

  @doc """
  Renders react component container. It can be called in a phoenix template or directly in a phoenix
  view.

  ## Using in a template filex

      ...
      <div>
        <%= PhoenixReactor.react_container("home", %{message: @message}) %>
      <div>
      ...

  ## Using in a view file

      def render("show.html", assigns) do
        PhoenixReactor.react_container("home", assigns[:props])
      end

  ## Examples:
      iex> PhoenixReactor.react_container("home")
      {:safe, ["<div data-react-component=\\"home\\" data-react-props=\\"{}\\">", "", "</div>"]}

      iex> PhoenixReactor.react_container("home", %{your_message: "Hello World"})
      {:safe,
        ["<div data-react-component=\\"home\\" data-react-props=\\"{&quot;yourMessage&quot;:&quot;Hello World&quot;}\\">",
        "",
        "</div>"]}

      iex> PhoenixReactor.react_container("home", %{your_message: "Hello World"}, class: "container", id: "home")
      {:safe,
        ["<div class=\\"container\\" data-react-component=\\"home\\" data-react-props=\\"{&quot;yourMessage&quot;:&quot;Hello World&quot;}\\" id=\\"home\\">",
        "",
        "</div>"]}
  """
  @spec react_container(String.t | atom, map, Keyword.t) :: {:safe, list} | {:error, any}
  def react_container(name, props \\ %{}, html_attrs \\ [])
  when is_map(props) and is_list(html_attrs) do
    attrs = Keyword.merge(html_attrs, react_data_attrs(name, props))
    content_tag(:div, "", attrs)
  end

  defp react_data_attrs(name, props) do
    react_props =
      props
      |> camelize
      |> to_json
    [data: ["#{@data_react_component}": name, "#{@data_react_props}": react_props]]
  end

  defp to_json(map) when is_map(map) do
    {:ok, json} = Poison.encode(map)
    json
  end

  defp camelize(map) when is_map(map) do
    map
    |> Enum.map(fn {x,y} -> {camelize(x), y} end)
    |> Enum.into(%{})
  end

  defp camelize(text) when is_atom(text) or is_binary(text) do
    Regex.replace ~r/_\w/, to_string(text), fn x, _ ->
      String.at(x, 1) |> String.upcase
    end
  end
end
