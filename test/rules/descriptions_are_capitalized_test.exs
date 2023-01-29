defmodule AbsintheLinter.Rules.DescriptionsAreCapitalizedTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @invalid_schema """
  defmodule InvalidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.DescriptionsAreCapitalized]

    query do
      @desc "invalid"
      field :test, :string
    end
  end
  """

  @valid_schema """
  defmodule ValidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.DescriptionsAreCapitalized]

    query do
      field :test, :string, description: "Valid"
    end
  end
  """

  test "logs error" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@invalid_schema, [], __ENV__)
           end) =~ "The description must start with a capital letter on node `test`"
  end

  test "does not logs error" do
    refute capture_io(:stderr, fn ->
             Code.eval_string(@valid_schema, [], __ENV__)
           end) =~ "The description must start with a capital letter on node `test`"
  end
end
