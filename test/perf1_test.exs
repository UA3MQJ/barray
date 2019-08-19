defmodule Perf1Test do
  use ExUnit.Case, async: false
  doctest Barray
  require Logger
  import Gnuplot

  @tag perf1_test: true
  # mix test --only perf1_test

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
      key = avg_result

      [xx, avg_result]
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

  # =================
    arr = Barray.new(1, 1024*1024*1024*1024)
      times2 = for x <- 1..5000 do
  
          idx = :rand.uniform(1024*1024*1024*1024)
          t1=:erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
          _el = Barray.get(arr, 1, idx)
          t2=:erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
  
        [x, (t2 - t1)]
      end
  
      times = times2
      |> Enum.reduce(%{}, fn([_, time], acc) ->
        key = Kernel.round(time)
        case Map.get(acc, key) do
          nil -> Map.merge(acc, %{key => 1})
          val -> Map.merge(acc, %{key => val + 1})
        end
      end)
      |> Enum.map(fn({tm, cnt}) -> [tm, cnt] end)
      |> Enum.filter(fn([tm1, cnt2]) -> tm1 < 5000 end)
      |> Enum.sort_by(fn([tm1, cnt2]) -> tm1 end)
  
      Logger.debug ">>>>> create_times=#{inspect create_times}"
      Logger.debug ">>>>> times=#{inspect times}"  

    {:ok, _cmd} = plot([
      [:set, :term, :pngcairo],
      [:set, :output, "./create_1k_time.png"],
      [:set, :title, "Time distribution"],
      [:set, :xlabel, "Time ns"],
      [:set, :ylabel, "Count"],
      [:set, :key, :left, :top],
      plots([
          ["-", :title, "cnt", :with, :line]
      ])
      ],
      [
        times
      ])
  end

end
