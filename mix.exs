defmodule Machete.MixProject do
  use Mix.Project

  def project do
    [
      app: :machete,
      version: "0.2.8",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      dialyzer: dialyzer(),
      name: "Machete",
      description: "Literate test matchers for ExUnit",
      source_url: "https://github.com/mtrudel/machete",
      package: [
        files: ["lib", "test", "mix.exs", "README*", "LICENSE*"],
        maintainers: ["Mat Trudel"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/mtrudel/machete"}
      ],
      docs: docs()
    ]
  end

  def application, do: []

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp dialyzer do
    [plt_core_path: "priv/plts", plt_file: {:no_warn, "priv/plts/dialyzer.plt"}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      main: "Machete",
      groups_for_modules: [
        Matchers: [
          Machete.AllMatcher,
          Machete.AnyMatcher,
          Machete.AtomMatcher,
          Machete.BooleanMatcher,
          Machete.DateMatcher,
          Machete.DateTimeMatcher,
          Machete.FalsyMatcher,
          Machete.FloatMatcher,
          Machete.InAnyOrderMatcher,
          Machete.IndifferentAccessMatcher,
          Machete.IntegerMatcher,
          Machete.IsAMatcher,
          Machete.ISO8601DateTimeMatcher,
          Machete.ListMatcher,
          Machete.MapMatcher,
          Machete.MaybeMatcher,
          Machete.NaiveDateTimeMatcher,
          Machete.NoneMatcher,
          Machete.PIDMatcher,
          Machete.PortMatcher,
          Machete.ReferenceMatcher,
          Machete.StringMatcher,
          Machete.StructLikeMatcher,
          Machete.SubsetMatcher,
          Machete.SupersetMatcher,
          Machete.TermMatcher,
          Machete.TimeMatcher,
          Machete.TruthyMatcher,
          Machete.UnixTimeMatcher
        ]
      ]
    ]
  end
end
