defmodule AbsintheLinter.Rules.EnumValuesHaveDescriptionsTest do
  use ExUnit.Case
  import TestHelper

  @warning "Enum values don't have descriptions"

  @schema """
  defmodule InvalidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.EnumValuesHaveDescriptions]

    query do
    end

    enum :color_channel do
      value :red, as: :r
    end
  end
  """

  test "should log errors for enums without description" do
    assert_capture_io(@schema, @warning)
  end

  @schema """
  defmodule ValidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.EnumValuesHaveDescriptions]

    query do
    end

    enum :color_channel do
      value :orange, as: :o, description: "Orange"
    end
  end
  """

  test "should not log errors for enums with description" do
    refute_capture_io(@schema, @warning)
  end
end
