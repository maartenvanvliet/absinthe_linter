defmodule AbsintheLinter.Rules.DeprecationsHaveReason do
  @moduledoc """
  Ensure deprecations in your schema declare a reason.
  """
  @behaviour Absinthe.Phase
  alias Absinthe.Blueprint

  def run(blueprint, _options \\ []) do
    blueprint = Blueprint.prewalk(blueprint, &validate_node/1)

    {:ok, blueprint}
  end

  defp validate_node(%{deprecation: %{reason: reason}} = node) when not is_binary(reason) do
    node |> AbsintheLinter.Rule.put_warning(error(node))
  end

  defp validate_node(node) do
    node
  end

  defp error(node) do
    %AbsintheLinter.Error{
      message: "Deprecation has no reason on node `#{node.name}`",
      locations: [node.__reference__.location],
      phase: __MODULE__
    }
  end
end
