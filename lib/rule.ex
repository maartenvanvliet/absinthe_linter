defmodule AbsintheLinter.Rule do
  def put_warning(node, error) do
    if node.__private__[:linter_skip] do
      node
    else
      update_in(node.__private__[:linter_warnings], fn
        nil -> [error]
        val -> [error | val]
      end)
    end
  end
end
