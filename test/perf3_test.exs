defmodule Perf3Test do
    use ExUnit.Case, async: false
    doctest Barray
    require Logger
    import Gnuplot
  
    @tag perf3_test: true
    # mix test --only perf3_test

    test "perf read test 1G" do
  
      arr = Barray.new(1, 1024*1024*1024*1024)

      create_times = for x <- 1..1000 do

        xx = (x * 1) * 1024*1024*1024
  
        t1=:erlang.monotonic_time(:nanosecond)
        _element = Barray.get(arr, 1, xx)
        t2=:erlang.monotonic_time(:nanosecond)
  
        [xx, (t2-t1) / 1]
      end
  
      {:ok, _cmd} = plot([
        [:set, :term, :pngcairo],
        [:set, :output, "./get_1g.png"],
        [:set, :title, "Get element time of A(n) each element equ 1 byte, n=1G"],
        [:set, :xlabel, "n"],
        [:set, :ylabel, "Time (ns)"],
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
  