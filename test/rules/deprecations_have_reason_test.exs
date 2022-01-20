defmodule AbsintheLinter.Rules.DeprecationsHaveReasonTest do
  use ExUnit.Case

  @schema """
  defmodule Schema do
    use Absinthe.Schema

    @pipeline_modifier AbsintheLinter.Rules.DeprecationsHaveReasonTest

    query do
      field :test, :string do
        deprecate true
      end
    end
  end
  """

  def pipeline(pipeline) do
    pipeline
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.Validation.UniqueFieldNames,
      AbsintheLinter.Rules.DeprecationsHaveReason
    )
  end

  test "raises error" do
    message = ~r/Deprecation has no reason on node `test`/

    assert_raise(Absinthe.Schema.Error, message, fn ->
      Code.eval_string(@schema, [], __ENV__)
    end)
  end
end
