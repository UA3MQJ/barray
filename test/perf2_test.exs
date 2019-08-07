defmodule Perf2Test do
  use ExUnit.Case, async: false
  doctest Barray
  require Logger
  import Gnuplot

  test "perf test 1m" do
    create_times = for x <- [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 10000] do
      xx = x * 1
      
        t1=:erlang.monotonic_time(:nanosecond)
        _arr = Barray.new(1024*1024*1024, xx)
        t2=:erlang.monotonic_time(:nanosecond)

      [xx, (t2-t1) / 1000000000]
    end

    {:ok, _cmd} = plot([
      [:set, :term, :pngcairo],
      [:set, :output, "./create_1m.png"],
      [:set, :title, "Create time of A(n) each element equ 1Mb"],
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
