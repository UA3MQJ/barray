defmodule Barray.MixProject do
  use Mix.Project

  def project do
    [
      app: :barray,
      version: "1.0.1",
      elixir: "~> 1.9",
      compilers: [:elixir_make] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:gnuplot, "~> 1.19", only: :test},
      {:elixir_make, "~> 0.4", runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
    ]
  end
end
