defmodule BarrayTest do
  use ExUnit.Case
  doctest Barray
  require Logger

  test "new test" do
    # new
    _t1 = :erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
    arr = Barray.new(1024, 1024*1024)
    _t2 = :erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
    # Logger.debug ">>>>>> new time #{t2-t1} ns"

    # get
    _t3 = :erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
    _data = arr |> Barray.get(1024, 1000)
    _t4 = :erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
    # Logger.debug ">>>>>> get data #{t4-t3} ns data=#{inspect data}"

    # update
    new_data = :binary.copy(<<255>>, 1024)
    _t5 = :erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
    arr = arr |> Barray.set(new_data, 666_666)
    _t6 = :erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
    # Logger.debug ">>>>>> update time #{t6-t5} ns"

    # get again
    _t7 = :erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
    data2 = arr |> Barray.get(1024, 666_666)
    _t8 = :erlang.monotonic_time(:nanosecond) # - 1/1000000000 секунды
    # Logger.debug ">>>>>> get time #{t8-t7} ns"
    assert new_data == data2
  end
end
