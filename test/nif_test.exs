defmodule NifTest do
  use ExUnit.Case, async: false
  doctest Barray
  require Logger

  # mix test --only nif_test

  @tag nif_test: true
  test "make_binary test" do
    arr = UtilsNif.make_binary(1000000)
    assert :erlang.size(arr) == 1000000
  end

  @tag nif_test: true
  test "update_binary test" do
    arr = <<1, 2, 3, 4, 5, 6, 7>>
    new_arr = UtilsNif.update_binary(arr, <<0, 0>>, 0)
    assert <<0, 0, 3, 4, 5, 6, 7>> = new_arr
  end

  @tag nif_test: true
  test "get_sub_binary test" do
    arr = <<1, 2, 3, 4, 5, 6, 7>>
    sub_arr = UtilsNif.get_sub_binary(arr, 2, 1)
    assert <<3, 4>> = sub_arr
  end

  @tag nif_test: true
  test "dirty_update_binary test" do
    arr = <<1, 2, 3, 4, 5, 6, 7>>

    # update test
    :ok = UtilsNif.dirty_update_binary(arr, <<0, 0>>, 0)
    assert <<0, 0, 3, 4, 5, 6, 7>> == arr
    arr = UtilsNif.dirty_update_binary(arr, <<0, 0>>, 1)
    assert <<0, 0, 0, 0, 5, 6, 7>> = arr
    arr = UtilsNif.dirty_update_binary(arr, <<0, 0>>, 2)
    assert <<0, 0, 0, 0, 0, 0, 7>> = arr
    arr = UtilsNif.dirty_update_binary(arr, <<0>>, 6)
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
  