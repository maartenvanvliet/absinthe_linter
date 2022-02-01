defmodule AbsintheLinter.Result do
  alias Absinthe.Blueprint

  require Logger

  def run(input, _options) do
    {input, warnings} = Blueprint.prewalk(input, [], &handle_node/2)

    Enum.each(warnings, fn warning ->
      warning |> print_error |> IO.warn([])
    end)

    {:ok, input}
  end

  defp handle_node(%{__private__: private} = node, warnings) when private != [] do
    if private[:linter_warnings] do
      {node, :lists.reverse(private[:linter_warnings]) ++ warnings}
    else
      {node, warnings}
    end
  end

  defp handle_node(%{identifier: :testy} = node, acc) do
    {node, acc}
  end

  defp handle_node(node, acc), do: {node, acc}

  defp print_error(error) do
    """
    #{error.message}. Found in

    #{Enum.map_join(error.locations, "\n", fn location -> "  #{location.file}:#{location.line}" end)}
    """
  end
end
