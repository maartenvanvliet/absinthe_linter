defmodule Schema1 do
  use Absinthe.Schema

  use AbsintheLinter, rules: [AbsintheLinter.Rules.EnumValuesHaveDescriptions]

  query do
  end

  enum :color_channel do
    value(:red, as: :r)
  end
end
