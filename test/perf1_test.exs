defmodule Perf1Test do
  use ExUnit.Case, async: false
  doctest Barray
  require Logger
  import Gnuplot

  test "perf test 1k" do

    _warm_up = for x <- 100..1000 do
        _arr = Barray.new(1024*1024, x)
    end

    create_times = for x <- 1..1000 do

      xx = x * 1
      avg = 50

      results = for _n <- 1..avg do
        t1=:erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
        _arr = Barray.new(1024*1024, xx)
        t2=:erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
        (t2 - t1)
      end

      avg_result = Enum.sum(results) / avg

      [xx, avg_result / 1000000000]
    end

    {:ok, _cmd} = plot([
      [:set, :term, :pngcairo],
      [:set, :output, "./create_1k.png"],
      [:set, :title, "Create time of A(n) each element equ 1Kb"],
      [:set, :xlabel, "n"],
      [:set, :ylabel, "Time (s)"],
      [:set, :key, :left, :top],
      plots([
          ["-", :title, "create time", :with, :line]
      ])
      ],
      [
        create_times
      ])
  end

end
