defmodule DirtySetTest do
  use ExUnit.Case, async: false
  doctest Barray
  require Logger
  import Gnuplot

  @tag dirty_set_test: true
  # mix test --only dirty_set_test

  test "dirty_set_test" do
    arr = <<1, 2, 3, 4, 5, 6, 7>>

    # update test
    :ok = UtilsNif.dirty_update_binary(arr, <<0, 0>>, 0)
    assert <<0, 0, 3, 4, 5, 6, 7>> = arr
    :ok = UtilsNif.dirty_update_binary(arr, <<0, 0>>, 1)
    assert <<0, 0, 0, 0, 5, 6, 7>> = arr
    :ok = UtilsNif.dirty_update_binary(arr, <<0, 0>>, 2)
    assert <<0, 0, 0, 0, 0, 0, 7>> = arr
    :ok = UtilsNif.dirty_update_binary(arr, <<0>>, 6)
    assert <<0, 0, 0, 0, 0, 0, 0>> = arr

    # check diapazone
    assert_raise ArgumentError, fn ->
      UtilsNif.dirty_update_binary(arr, <<0, 0>>, -1)
    end
    assert_raise ArgumentError, fn ->
      UtilsNif.dirty_update_binary(arr, <<0, 0>>, 3)
    end
  end
  
end
  