defmodule AbsintheLinter.Rules.RequireInputObjectsListsOfNonNullTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @invalid_schema """
  defmodule InvalidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [
      AbsintheLinter.Rules.RequireNonNullListsOfNonNull,
      AbsintheLinter.Rules.RequireInputObjectsListsOfNonNull
    ]

    query do
    end

    input_object :params do
      field :test_input_object_list, list_of(:string)
    end
  end
  """

  @valid_schema """
  defmodule ValidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [
      AbsintheLinter.Rules.RequireNonNullListsOfNonNull,
      AbsintheLinter.Rules.RequireInputObjectsListsOfNonNull
    ]

    input_object :params do
      field :test_input_object_list, list_of(non_null(:string))
    end

    query do
      field :test_list_in_query, list_of(:string)
    end
  end
  """

  def pipeline(pipeline) do
    pipeline
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.Validation.UniqueFieldNames,
      [
        AbsintheLinter.Rules.RequireNonNullListsOfNonNull,
        AbsintheLinter.Rules.RequireInputObjectsListsOfNonNull
      ]
    )
  end

  test "logs error" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@invalid_schema, [], __ENV__)
           end) =~ "Found input object with nullable list items `test_input_object_list`."
  end

  test "does not logs error if not an input_object" do
    refute capture_io(:stderr, fn ->
             Code.eval_string(@valid_schema, [], __ENV__)
           end) =~ "Found input object with nullable list items `test_list_in_query`."
  end

  test "does not logs error" do
    refute capture_io(:stderr, fn ->
             Code.eval_string(@valid_schema, [], __ENV__)
           end) =~ "Found input object with nullable list items `test_input_object_list`."
  end
end
