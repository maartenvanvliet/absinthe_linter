defmodule AbsintheLinter.Rules.DeprecationsHaveReasonTest do
  use ExUnit.Case
  import TestHelper

  @warning "Deprecation has no reason on node"

  @schema """
  defmodule Schema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.DeprecationsHaveReason]

    query do
      field :test_deprecate_without_description, :string do
        deprecate true
      end

      field :test_deprecate_with_description, :string, deprecate: "still too old"
    end
  end
  """

  test "should log error for deprecate field without description" do
    assert_capture_io(@schema, "#{@warning} `test_deprecate_without_description`")
  end

  test "should not log error for obsolete field with description" do
    refute_capture_io(@schema, "#{@warning} `test_deprecate_with_description`")
  end
end
