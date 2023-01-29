defmodule AbsintheLinter.Rules.RequireNonNullLists do
  @moduledoc """
  Ensure don't have null lists.
  """
  @behaviour Absinthe.Phase
  alias Absinthe.Blueprint
  alias Absinthe.Blueprint.TypeReference

  def run(blueprint, _options \\ []) do
    blueprint = Blueprint.prewalk(blueprint, &validate_node/1)

    {:ok, blueprint}
  end

  defp validate_node(%{__reference__: %{module: Absinthe.Type.BuiltIns.Introspection}} = node) do
    node
  end

  defp validate_node(%Blueprint.Schema.FieldDefinition{type: %TypeReference.List{}} = node) do
    node |> AbsintheLinter.Rule.put_warning(error(node))
  end

  defp validate_node(node) do
    node
  end

  defp error(node) do
    %AbsintheLinter.Error{
      message: "Found nullable list `#{node.name}`",
      locations: [node.__reference__.location],
      phase: __MODULE__
    }
  end
end
