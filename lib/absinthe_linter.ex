defmodule AbsintheLinter do
  @external_resource "./README.md"
  @moduledoc """
  #{File.read!(@external_resource) |> String.split("<!-- MDOC !-->", parts: 2) |> List.last()}
  """

  alias AbsintheLinter.Rules

  defmacro __using__(opts) do
    quote do
      @pipeline_modifier {__MODULE__, :__absinthe_linter_pipeline__}

      def __absinthe_linter_pipeline__(pipeline) do
        if unquote(opts)[:rules] == nil do
          AbsintheLinter.pipeline(pipeline, AbsintheLinter.default_rules(), unquote(opts))
        else
          AbsintheLinter.pipeline(pipeline, unquote(opts)[:rules], unquote(opts))
        end
      end
    end
  end

  @default_rules [
    Rules.DeprecationsHaveReason,
    Rules.EnumValuesHaveDescriptions,
    Rules.EnumValuesSortedAlphabetically,
    Rules.RequireNonNullLists,
    Rules.RequireListsOfNonNull
  ]

  @doc """
  Default pipeline, applies all default rules
  """
  def pipeline(pipeline, rules \\ @default_rules, opts \\ []) do
    only = opts[:only]
    except = opts[:except] || []

    rules =
      rules
      |> Enum.reject(&(&1 in except))
      |> Enum.filter(&(only == nil || &1 in only))

    pipeline
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.Validation.UniqueFieldNames,
      rules
    )
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.ReformatDescriptions,
      AbsintheLinter.Result
    )
  end

  @doc """
  The default rules are:
  #{@default_rules |> Enum.map(&" * `#{inspect(&1)}` \n")}
  """
  def default_rules do
    @default_rules
  end
end
