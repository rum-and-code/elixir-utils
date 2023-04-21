defmodule Utils.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_utils,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      preferred_cli_env: [pipeline: :test]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:timex, "~> 3.7.11"}
    ]
  end

  defp aliases do
    [
      pipeline: ["format --check-formatted", "compile --warnings-as-errors", "test", "credo"]
    ]
  end
end
