defmodule AbsintheLinter.Rules.DescriptionsAreCapitalized do
  @moduledoc """
  Ensure descriptions start with a capital letter.
  """
  @behaviour Absinthe.Phase
  alias Absinthe.Blueprint

  def run(blueprint, _options \\ []) do
    blueprint = Blueprint.prewalk(blueprint, &validate_node/1)

    {:ok, blueprint}
  end

  defp validate_node(%{description: <<char::binary-size(1), _rest::binary>>} = node) do
    if String.upcase(char) == char do
      node
    else
      node |> AbsintheLinter.Rule.put_warning(error(node))
    end
  end

  defp validate_node(node) do
    node
  end

  defp error(node) do
    %AbsintheLinter.Error{
      message: "The description must start with a capital letter on node `#{node.name}`",
      locations: [node.__reference__.location],
      phase: __MODULE__
    }
  end
end
