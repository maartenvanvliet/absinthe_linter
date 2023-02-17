defmodule AbsintheLinter.Rules.RequireNonNullListsOfNonNullTest do
  use ExUnit.Case
  import TestHelper

  @warning "Found nullable lists of nullable items"

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

  test "should log error for nullable lists" do
    assert_capture_io(@invalid_schema, "#{@warning} `test_nullable_list`.")
  end

  test "should log error for nullable list items" do
    assert_capture_io(@invalid_schema, "#{@warning} `test_nullable_list_items`.")
  end

  test "should log error for nullable list items in objects" do
    assert_capture_io(@invalid_schema, "#{@warning} `test_list_object`.")
  end

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

  test "should not log errors for properly configured fields" do
    refute_capture_io(@valid_schema, "#{@warning} `test_list_query`.")
  end

  test "should not log errors for input objects" do
    refute_capture_io(@valid_schema, "#{@warning} `test_input_object_list`.")
  end
end
