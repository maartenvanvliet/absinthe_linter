defmodule AbsintheLinter.Rules.EnumValuesHaveDescriptionsTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @schema """
  defmodule Schema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.EnumValuesHaveDescriptions]

    query do
    end

    enum :color_channel do
      value :red, as: :r
    end
  end
  """

  test "node has linting warning" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@schema, [], __ENV__)
           end) =~ "Enum values don't have descriptions"
  end
end
