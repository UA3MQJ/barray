defmodule Perf4Test do
    use ExUnit.Case, async: false
    doctest Barray
    require Logger
    import Gnuplot
  
    @tag perf4_test: true
    # mix test --only perf4_test

    test "perf write test 1Mb" do
  
      arr = Barray.new(1, 1024*1024*1024)

      create_times = for x <- 1..100 do

        xx = (x * 10) * 1024 * 1024
  
        t1=:erlang.monotonic_time(:nanosecond)
        arr = Barray.set(arr, <<0>>, xx)
        t2=:erlang.monotonic_time(:nanosecond)
  
        [x, (t2-t1) / 1000000000]
      end
  
      {:ok, _cmd} = plot([
        [:set, :term, :pngcairo],
        [:set, :output, "./set.png"],
        [:set, :title, "Set element time of A(1Mb) each element equ 1 byte"],
        [:set, :xlabel, "n"],
        [:set, :ylabel, "Time (s)"],
        [:set, :key, :left, :top],
        plots([
            ["-", :title, "get time", :with, :line]
        ])
        ],
        [
          create_times
        ])
    end
  
end
  