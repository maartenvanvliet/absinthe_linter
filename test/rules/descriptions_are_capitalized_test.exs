defmodule AbsintheLinter.Rules.DescriptionsAreCapitalizedTest do
  use ExUnit.Case
  import TestHelper

  @warning "The description must start with a capital letter on node"

  @schema """
  defmodule InvalidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.DescriptionsAreCapitalized]

    query do
      @desc "invalid"
      field :test_with_description_not_capitalized, :string

      field :test_with_description_capitalized, :string, description: "Valid"
    end
  end
  """

  test "should log error for field with description not capitalized" do
    assert_capture_io(@schema, "#{@warning} `test_with_description_not_capitalized`.")
  end

  test "should not log error for field with description capitalized" do
    refute_capture_io(@schema, "#{@warning} `test_with_description_capitalized`.")
  end
end
