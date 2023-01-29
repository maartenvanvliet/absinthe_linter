defmodule AbsintheLinter.Rules.EnumValuesSortedAlphabeticallyTest do
  use ExUnit.Case
  import TestHelper

  @warning "Enum values are not sorted alphabetically"

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

  test "logs error for enum" do
    assert_capture_io(@schema, @warning)
  end

  @schema """
  defmodule SchemaShorthand do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.EnumValuesSortedAlphabetically]

    query do
    end

    enum :color_channel, values: [:red, :green, :blue, :alpha]
  end
  """

  test "logs error for shorthand" do
    assert_capture_io(@schema, @warning)
  end
end
