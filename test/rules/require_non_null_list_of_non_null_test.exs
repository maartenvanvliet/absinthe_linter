defmodule AbsintheLinter.Rules.RequireNonNullListsOfNonNullTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @schema """
  defmodule Schema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.RequireNonNullListsOfNonNull]

    query do
      field :test_list, list_of(:string)
    end
  end
  """

  def pipeline(pipeline) do
    pipeline
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.Validation.UniqueFieldNames,
      AbsintheLinter.Rules.RequireNonNullListsOfNonNull
    )
  end

  test "logs error" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@schema, [], __ENV__)
           end) =~ "Found nullable list `test_list`."
  end
end
