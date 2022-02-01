defmodule AbsintheLinter.Rules.EnumValuesHaveDescriptions do
  @moduledoc """
  Ensure enum values have descriptions.
  """
  @behaviour Absinthe.Phase
  alias Absinthe.Blueprint

  def run(blueprint, _options \\ []) do
    blueprint = Blueprint.prewalk(blueprint, &validate_node/1)

    {:ok, blueprint}
  end

  defp validate_node(%Blueprint.Schema.EnumValueDefinition{} = node) do
    if node.description != nil do
      node
    else
      # TODO: put warning on node when Absinthe 1.7.1 is released
      error = error(node)
      IO.warn(error.message, [])
      node
    end
  end

  defp validate_node(node) do
    node
  end

  defp error(node) do
    %AbsintheLinter.Error{
      message: "Enum values don't have descriptions",
      locations: [node.__reference__.location],
      phase: __MODULE__
    }
  end
end
