# AbsintheLinter

## [![Hex pm](http://img.shields.io/hexpm/v/absinthe_linter.svg?style=flat)](https://hex.pm/packages/absinthe_linter) [![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg)](https://hexdocs.pm/absinthe_linter) [![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)![.github/workflows/elixir.yml](https://github.com/maartenvanvliet/absinthe_linter/workflows/.github/workflows/elixir.yml/badge.svg)

<!-- MDOC !-->

Validate Absinthe GraphQL schema definitions against a set of rules.

Ported from https://github.com/cjoudrey/graphql-schema-linter

## Installation

```elixir
def deps do
  [
    {:absinthe_linter, "~> 0.1.0"}
  ]
end
```

## Usage

This linter adds phases in your Absinthe schema compilation. So, when your schema compiles it'll be linted.

In your Absinthe schema file you need to add a pipeline modifier with AbsintheLinter.

```elixir
defmodule Schema do
  use Absinthe.Schema

  @pipeline_modifier AbsintheLinter

  query do
  end
end
```

If you need more control, you can add your own pipeline modifier module. E.g.

```elixir
defmodule Schema do
  use Absinthe.Schema

  @pipeline_modifier {__MODULE__, :custom_linting_rules}

  query do
  end

  def custom_linting_rules(pipeline) do
    pipeline
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.Validation.UniqueFieldNames,
      [
        AbsintheLinter.Rules.DeprecationsHaveReason,
      ]
    )
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Schema.ReformatDescriptions,
      AbsintheLinter.Result
    )
  end
end
```

See the documentation for the rules.
