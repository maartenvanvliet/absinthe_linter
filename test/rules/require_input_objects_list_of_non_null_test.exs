defmodule AbsintheLinter.Rules.RequireInputObjectsListsOfNonNullTest do
  use ExUnit.Case
  import TestHelper

  @warning "Found input object with nullable list items"

  @invalid_schema """
  defmodule InvalidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.RequireInputObjectsListsOfNonNull]

    query do
    end

    input_object :params do
      field :test_input_object_list, list_of(:string)
      field :test_input_object_non_null_list, non_null(list_of(:string))
    end
  end
  """

  test "should log errors for input objects nullable lists items" do
    assert_capture_io(@invalid_schema, "#{@warning} `test_input_object_list`.")
  end

  test "should log errors for input objects non nullable lists but nullable items" do
    assert_capture_io(@invalid_schema, "#{@warning} `test_input_object_non_null_list`.")
  end

  @valid_schema """
  defmodule ValidSchema do
    use Absinthe.Schema

    use AbsintheLinter, rules: [AbsintheLinter.Rules.RequireInputObjectsListsOfNonNull]

    input_object :params do
      field :test_input_object_list, list_of(non_null(:string))
      field :test_input_object_non_null_list, non_null(list_of(non_null(:string)))
    end

    query do
      field :test_list_in_query, list_of(:string)
    end
  end
  """

  test "should not logs error if not an input_object" do
    refute_capture_io(@valid_schema, "#{@warning} `test_list_in_query`.")
  end

  test "should not log errors for non-nullable lists items of input objects" do
    refute_capture_io(@valid_schema, "#{@warning} `test_input_object_list`.")
  end

  test "should not log errors for non-nullable lists of non-nullable items of input objects" do
    refute_capture_io(@valid_schema, "#{@warning} `test_input_object_non_null_list`.")
  end
end
