defmodule AbsintheLinter.Error do
  @moduledoc false

  @enforce_keys [:message, :phase]
  defstruct [
    :message,
    :phase,
    locations: [],
    extra: %{},
    path: []
  ]

  @type loc_t :: %{optional(any) => any, line: pos_integer, column: pos_integer}

  @type t :: %__MODULE__{
          message: String.t(),
          phase: module,
          locations: [loc_t],
          path: [],
          extra: map
        }
end
