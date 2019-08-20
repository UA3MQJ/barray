defmodule Barray.MixProject do
  use Mix.Project

  def project do
    [
      app: :barray,
      version: "0.1.0",
      elixir: "~> 1.6",
      compilers: [:elixir_make] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
    ]
  end
end
