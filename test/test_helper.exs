ExUnit.start()

defmodule TestHelper do
  use ExUnit.Case
  import ExUnit.CaptureIO

  def assert_capture_io(schema, message) do
    assert capture_io_from_schema(schema) =~ message
  end

  def refute_capture_io(schema, message) do
    refute capture_io_from_schema(schema) =~ message
  end

  def capture_io_from_schema(schema) do
    capture_io(:stderr, fn -> eval_schema(schema) end)
  end

  def eval_schema(schema) do
    Code.eval_string(schema, [], __ENV__)
  end
end
