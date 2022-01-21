defmodule AbsintheLinter.MixProject do
  use Mix.Project

  @url "https://github.com/maartenvanvliet/absinthe_linter"
  def project do
    [
      app: :absinthe_linter,
      version: "0.1.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Linter for Absinthe",
      package: [
        maintainers: ["Maarten van Vliet"],
        licenses: ["MIT"],
        links: %{"GitHub" => @url},
        files: ~w(LICENSE README.md lib mix.exs .formatter.exs)
      ],
      docs: [
        canonical: "http://hexdocs.pm/absinthe_linter",
        source_url: @url,
        groups_for_modules: groups_for_modules(),
        nest_modules_by_prefix: [AbsintheLinter.Rules]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:absinthe, "~> 1.7.0"},
      {:ex_doc, "~> 0.27", only: [:dev, :test]}
    ]
  end

  defp groups_for_modules do
    [
      Rules: ~r/Rules/
    ]
  end
end
