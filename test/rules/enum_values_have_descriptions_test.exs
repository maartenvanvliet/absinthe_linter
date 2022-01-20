defmodule AbsintheLinter.Rules.EnumValuesHaveDescriptionsTest do
  use ExUnit.Case

  @schema """
  defmodule Schema do
    use Absinthe.Schema

    @pipeline_modifier #{__MODULE__}

    query do
    end

    enum :color_channel do
      value :red, as: :r
      value :green, as: :g, description: "Color Green"
      value :blue, as: :b, description: "Color Blue"
    end
  end
  """

  def pipeline(pipeline) do
    pipeline
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.Validation.UniqueFieldNames,
      AbsintheLinter.Rules.EnumValuesHaveDescriptions
    )
  end

  test "raises error" do
    message = ~r/Enum values don't have descriptions/

    assert_raise(Absinthe.Schema.Error, message, fn ->
      Code.eval_string(@schema, [], __ENV__)
    end)
  end
end
