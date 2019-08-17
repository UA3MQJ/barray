defmodule Perf5Test do
    use ExUnit.Case, async: false
    doctest Barray
    require Logger
    import Gnuplot
  
    @tag perf5_test: true
    # mix test --only perf5_test

    test "perf dirty_write test 1Mb" do
  
      arr = Barray.new(1, 1024*1024*1024)

      create_times = for x <- 1..1000 do

        xx = (x * 1) * 1024 * 1024
  
        t1=:erlang.monotonic_time(:nanosecond)
        :ok = Barray.dirty_set(arr, <<0>>, xx)
        t2=:erlang.monotonic_time(:nanosecond)
  
        [x, (t2-t1) / 1]
      end
  
      {:ok, _cmd} = plot([
        [:set, :term, :pngcairo],
        [:set, :output, "./dirty_set.png"],
        [:set, :title, "Set (dirty) element time of A(1Mb) each element equ 1 byte"],
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
  