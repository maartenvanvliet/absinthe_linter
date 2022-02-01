defmodule AbsintheLinterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias AbsintheLinter.Rules

  @schema """
  defmodule Schema do
    use Absinthe.Schema

    @pipeline_modifier AbsintheLinterTest
    use AbsintheLinter

    query do
    end
  end
  """

  def pipeline(pipeline) do
    send(self(), pipeline: pipeline)
    pipeline
  end

  test "adds linter phases to pipeline" do
    Code.eval_string(@schema, [], __ENV__)

    assert_receive pipeline: pipeline

    assert Rules.DeprecationsHaveReason in pipeline
    assert Rules.EnumValuesSortedAlphabetically in pipeline
    assert Rules.EnumValuesHaveDescriptions in pipeline
  end

  @schema """
  defmodule CustomLintingSchema do
    use Absinthe.Schema

    @pipeline_modifier AbsintheLinterTest
    @pipeline_modifier {__MODULE__, :custom_linting_rules}

    query do
    end

    def custom_linting_rules(pipeline) do
      pipeline
      |> Absinthe.Pipeline.insert_after(
        Absinthe.Phase.Schema.Validation.UniqueFieldNames,
        [
          Rules.DeprecationsHaveReason,
        ]
      )
    end
  end
  """

  test "adds custom linter phases to pipeline" do
    Code.eval_string(@schema, [], __ENV__)

    assert_receive pipeline: pipeline

    assert Rules.DeprecationsHaveReason in pipeline
    assert Rules.EnumValuesSortedAlphabetically not in pipeline
    assert Rules.EnumValuesHaveDescriptions not in pipeline
  end

  @schema """
  defmodule CustomLintingSchemaUsing do
    use Absinthe.Schema

    @pipeline_modifier AbsintheLinterTest
    use AbsintheLinter, rules: [Rules.DeprecationsHaveReason]

    query do
      field :testy, :string do

        deprecate true
      end
    end
  end
  """

  test "adds custom linter phases to pipeline with using" do
    try do
      capture_io(:stderr, fn ->
        Code.eval_string(@schema, [], __ENV__)
      end)
    rescue
      e -> e
    end

    assert_receive pipeline: pipeline

    assert Rules.DeprecationsHaveReason in pipeline
    assert Rules.EnumValuesSortedAlphabetically not in pipeline
    assert Rules.EnumValuesHaveDescriptions not in pipeline
  end

  test "outputs warnings" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@schema, [], __ENV__)
           end) =~ "Deprecation has no reason on node `testy`"
  end
end
