defmodule PerfTest do
  use ExUnit.Case
  doctest Barray
  require Logger
  import Gnuplot
  @tag timeout: 600_000

  @tag perf_test: true
  # mix test --only perf_test
  test "perf test 1k" do

    create_times = for x <- 1..25 do

      xx = x * 40
      avg = 1

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
          ["-", :title, "create time (kb)", :with, :line]
      ])
      ],
      [
        create_times
      ])
  end

  test "perf test 1m" do
    create_times = for x <- [1, 4, 16, 64] do
      IO.puts ("Size #{x} Mb")
      xx = x * 1
      
        t1=:erlang.monotonic_time(:second) # - 1 секунды
        _arr = Barray.new(1024*1024*1024, xx)
        t2=:erlang.monotonic_time(:second) # - 1 секунды

      [xx, (t2-t1)]
    end

    {:ok, _cmd} = plot([
      [:set, :term, :pngcairo],
      [:set, :output, "./create_1m.png"],
      [:set, :title, "Create time of A(n) each element equ 1Mb"],
      [:set, :xlabel, "n"],
      [:set, :ylabel, "Time (s)"],
      [:set, :key, :left, :top],
      plots([
          ["-", :title, "create time (kb)", :with, :line]
      ])
      ],
      [
        create_times
      ])

  end

end
