defmodule PerfTest do
  use ExUnit.Case, async: false
  doctest Barray
  require Logger
  # import Gnuplot

  @tag :perf
  test "perf test" do
  end

end
