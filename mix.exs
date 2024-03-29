defmodule Barray.MixProject do
  use Mix.Project

  def project do
    [
      app: :barray,
      version: "1.0.1",
      elixir: "~> 1.6",
      compilers: [:rustler] ++ [:elixir_make] ++ Mix.compilers(),
      rustler_crates: [rutils: []],
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
      {:gnuplot, git: "git@github.com:devstopfix/gnuplot-elixir.git"},
      {:elixir_make, "~> 0.6.0", runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:rustler, "~> 0.21.0"},
    ]
  end
end
