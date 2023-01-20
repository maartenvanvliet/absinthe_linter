defmodule AbsintheLinter.Rules.RequireNonNullListsTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @invalid_schema """
  defmodule InvalidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.RequireNonNullLists]

    query do
      field :test_list, list_of(:string)
    end
  end
  """

  @valid_schema """
  defmodule ValidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.RequireNonNullLists]

    query do
      field :test_list, non_null(list_of(:string))
    end
  end
  """

  def pipeline(pipeline) do
    pipeline
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.Validation.UniqueFieldNames,
      AbsintheLinter.Rules.RequireNonNullLists
    )
  end

  test "logs error" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@invalid_schema, [], __ENV__)
           end) =~ "Found nullable list `test_list`."
  end

  test "does not logs error" do
    refute capture_io(:stderr, fn ->
             Code.eval_string(@valid_schema, [], __ENV__)
           end) =~ "Found nullable list `test_list`."
  end
end
