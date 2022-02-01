defmodule AbsintheLinter.Rules.EnumValuesSortedAlphabeticallyTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @schema """
  defmodule Schema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.EnumValuesSortedAlphabetically]

    query do
    end

    enum :color_channel do
      value :red, as: :r, description: "Color Red"
      value :green, as: :g, description: "Color Green"
      value :blue, as: :b, description: "Color Blue"
    end
  end
  """

  test "logs error" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@schema, [], __ENV__)
           end) =~ "Enum values are not sorted alphabetically"
  end
end
