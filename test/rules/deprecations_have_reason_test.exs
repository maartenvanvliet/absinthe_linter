defmodule AbsintheLinter.Rules.DeprecationsHaveReasonTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @schema """
  defmodule Schema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.DeprecationsHaveReason]

    query do
      field :test, :string do

        deprecate true
      end
    end
  end
  """

  test "logs error" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@schema, [], __ENV__)
           end) =~ "Deprecation has no reason on node `test`"
  end
end
