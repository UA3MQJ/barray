defmodule GetTest do
  use ExUnit.Case, async: false
  doctest Barray
  require Logger
  import Gnuplot

  @tag get_test: true
  # mix test --only get_test

  test "dirty_set_test" do
    arr = <<1, 2, 3, 4, 5, 6, 7>>

    # update test
    assert <<1, 2>> = UtilsNif.get_sub_binary(arr, 2, 0)
    assert <<3, 4>> = UtilsNif.get_sub_binary(arr, 2, 1)
    assert <<5, 6>> = UtilsNif.get_sub_binary(arr, 2, 2)
    assert <<7>> = UtilsNif.get_sub_binary(arr, 1, 6)

    assert <<1, 2>> = Barray.get(arr, 2, 0)
    assert <<3, 4>> = Barray.get(arr, 2, 1)
    assert <<5, 6>> = Barray.get(arr, 2, 2)
    assert <<7>> = Barray.get(arr, 1, 6)

    # check diapazone
    assert_raise ArgumentError, fn ->
      UtilsNif.get_sub_binary(arr, 2, -1)
    end
    assert_raise ArgumentError, fn ->
      UtilsNif.update_binary(arr, 2, 3)
    end
  end
  
end
  