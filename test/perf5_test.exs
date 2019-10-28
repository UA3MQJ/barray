defmodule Perf5Test do
    use ExUnit.Case, async: false
    doctest Barray
    require Logger
    import Gnuplot
  
    @tag perf5_test: true
    # mix test --only perf5_test

    @tag :perf
    test "perf dirty_write test 1Mb" do
  
      arr = Barray.new(1, 1024*1024*1024)

      create_times = for x <- 1..1000 do

        xx = (x * 1) * 1024 * 1024

        avg = 10
  
        results = for _n <- 1..avg do
          t1=:erlang.monotonic_time(:nanosecond)
          _arr = Barray.dirty_set(arr, <<0>>, xx)
          t2=:erlang.monotonic_time(:nanosecond)
          (t2-t1)
        end

        avg_result = Enum.sum(results) / avg
  
        [xx, avg_result]

      end
  
      {:ok, _cmd} = plot([
        [:set, :term, :pngcairo],
        [:set, :output, "./dirty_set.png"],
        [:set, :title, "Set (dirty) element time of A(1Mb) each element equ 1 byte"],
        [:set, :xlabel, "n"],
        [:set, :ylabel, "Time (ns)"],
        [:set, :key, :left, :top],
        plots([
            ["-", :title, "set time", :with, :line]
        ])
        ],
        [
          create_times
        ])
    end
  
end
  