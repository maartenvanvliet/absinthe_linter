defmodule AbsintheLinter.Rules.EnumValuesSortedAlphabeticallyTest do
  use ExUnit.Case

  @schema """
  defmodule Schema do
    use Absinthe.Schema

    @pipeline_modifier AbsintheLinter.Rules.EnumValuesSortedAlphabeticallyTest

    query do
    end

    enum :color_channel do
      value :red, as: :r, description: "Color Red"
      value :green, as: :g, description: "Color Green"
      value :blue, as: :b, description: "Color Blue"
    end
  end
  """

  def pipeline(pipeline) do
    pipeline
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.Validation.UniqueFieldNames,
      AbsintheLinter.Rules.EnumValuesSortedAlphabetically
    )
  end

  test "raises error" do
    message = ~r/Enum values are not sorted alphabetically/

    assert_raise(Absinthe.Schema.Error, message, fn ->
      Code.eval_string(@schema, [], __ENV__)
    end)
  end
end
