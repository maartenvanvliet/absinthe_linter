defmodule AbsintheLinter.Rules.EnumValuesHaveDescriptionsTest do
  use ExUnit.Case
  import TestHelper

  @warning "Enum values don't have descriptions"

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
    assert_capture_io(@schema, @warning)
  end
end
