defmodule SetTest do
  use ExUnit.Case, async: false
  doctest Barray
  require Logger
  import Gnuplot

  @tag set_test: true
  # mix test --only set_test

  test "dirty_set_test" do
    arr = <<1, 2, 3, 4, 5, 6, 7>>

    # update test
    assert <<0, 0, 3, 4, 5, 6, 7>> = UtilsNif.update_binary(arr, <<0, 0>>, 0)
    assert <<1, 2, 0, 0, 5, 6, 7>> = UtilsNif.update_binary(arr, <<0, 0>>, 1)
    assert <<1, 2, 3, 4, 0, 0, 7>> = UtilsNif.update_binary(arr, <<0, 0>>, 2)
    assert <<1, 2, 3, 4, 5, 6, 0>> = UtilsNif.update_binary(arr, <<0>>, 6)

    # check diapazone
    assert_raise ArgumentError, fn ->
      UtilsNif.update_binary(arr, <<0, 0>>, -1)
    end
    assert_raise ArgumentError, fn ->
      UtilsNif.update_binary(arr, <<0, 0>>, 3)
    end
  end
  
end
  