defmodule AbsintheLinter.Rules.RequireNonNullListsOfNonNullTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @invalid_schema """
  defmodule InvalidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.RequireNonNullListsOfNonNull]

    object :obj do
      field :test_list_object, list_of(non_null(:string))
    end

    query do
      field :test_nullable_list, list_of(non_null(:string))
      field :test_nullable_list_items, non_null(list_of(:string))
    end
  end
  """

  @valid_schema """
  defmodule ValidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.RequireNonNullListsOfNonNull]

    input_object :params do
      field :test_input_object_list, list_of(:string)
    end

    query do
      field :test_list_query, non_null(list_of(non_null(:string)))
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

  test "logs error for nullable lists" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@invalid_schema, [], __ENV__)
           end) =~ "Found nullable lists of nullable items `test_nullable_list`."
  end

  test "logs error for nullable list items" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@invalid_schema, [], __ENV__)
           end) =~ "Found nullable lists of nullable items `test_nullable_list_items`."
  end

  test "logs error for nullable list items in objects" do
    assert capture_io(:stderr, fn ->
             Code.eval_string(@invalid_schema, [], __ENV__)
           end) =~ "Found nullable lists of nullable items `test_list_object`."
  end

  test "does not logs error" do
    refute capture_io(:stderr, fn ->
             Code.eval_string(@valid_schema, [], __ENV__)
           end) =~ "Found nullable lists of nullable items `test_list_query`."
  end

  test "does not logs error for input objects" do
    refute capture_io(:stderr, fn ->
             Code.eval_string(@valid_schema, [], __ENV__)
           end) =~ "Found nullable lists of nullable items `test_input_object_list`."
  end
end
