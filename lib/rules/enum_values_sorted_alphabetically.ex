defmodule AbsintheLinter.Rules.EnumValuesSortedAlphabetically do
  @moduledoc """
  Ensure enum values are sorted alphabetically.
  """
  @behaviour Absinthe.Phase
  alias Absinthe.Blueprint

  def run(blueprint, _options \\ []) do
    blueprint = Blueprint.prewalk(blueprint, &validate_node/1)

    {:ok, blueprint}
  end

  defp validate_node(%Blueprint.Schema.EnumTypeDefinition{name: "__" <> _} = node) do
    node
  end

  defp validate_node(%Blueprint.Schema.EnumTypeDefinition{} = node) do
    if sorted_values?(node) do
      node
    else
      node |> AbsintheLinter.Rule.put_warning(error(node))
    end
  end

  defp validate_node(node) do
    node
  end

  # List.flatten is used to handle the shorthand enum values
  defp sorted_values?(node) do
    node.values |> List.flatten() |> Enum.sort_by(&sort_key/1) == List.flatten(node.values)
  end

  defp sort_key(%{name: name}), do: name
  defp sort_key(value), do: value

  defp error(node) do
    %AbsintheLinter.Error{
      message: "Enum values are not sorted alphabetically",
      locations: [node.__reference__.location],
      phase: __MODULE__
    }
  end
end
