defmodule AbsintheLinter.Rules.RequireInputObjectsListsOfNonNull do
  @moduledoc """
  Ensure input objects don't have lists with null items.
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

  defp validate_node(%Blueprint.Schema.InputObjectTypeDefinition{fields: fields} = node) do
    %{node | fields: Enum.map(fields, &validate_child_node/1)}
  end

  defp validate_node(node) do
    node
  end

  defp validate_child_node(
         %Blueprint.Schema.FieldDefinition{
           type: %TypeReference.List{of_type: inner_type}
         } = node
       ) do
    case inner_type do
      %TypeReference.NonNull{} -> node
      _ -> node |> AbsintheLinter.Rule.put_warning(error(node))
    end
  end

  defp validate_child_node(
         %Blueprint.Schema.FieldDefinition{
           type: %TypeReference.NonNull{of_type: %TypeReference.List{of_type: inner_type}}
         } = node
       ) do
    case inner_type do
      %TypeReference.NonNull{} -> node
      _ -> node |> AbsintheLinter.Rule.put_warning(error(node))
    end
  end

  defp validate_child_node(node) do
    node
  end

  defp error(node) do
    %AbsintheLinter.Error{
      message: "Found input object with nullable list items `#{node.name}`",
      locations: [node.__reference__.location],
      phase: __MODULE__
    }
  end
end
