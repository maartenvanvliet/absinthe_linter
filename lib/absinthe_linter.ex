defmodule AbsintheLinter do
  @external_resource "./README.md"
  @moduledoc """
  #{File.read!(@external_resource) |> String.split("<!-- MDOC !-->", parts: 2) |> List.last()}
  """

  alias AbsintheLinter.Rules

  @doc """
  Default pipeline, applies all default rules
  """
  def pipeline(pipeline) do
    pipeline
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.Validation.UniqueFieldNames,
      default_rules()
    )
  end

  @default_rules [
    Rules.DeprecationsHaveReason,
    Rules.EnumValuesHaveDescriptions,
    Rules.EnumValuesSortedAlphabetically
  ]
  @doc """
  The default rules are:
  #{@default_rules |> Enum.map(&" * `#{inspect(&1)}` \n")}
  """
  def default_rules do
    @default_rules
  end
end
