defmodule Barray do
  @moduledoc """
  Documentation for Barray.
  """

  @doc """
  Hello world.

  ## Examples

  new
  arr = ArrTest.new(1024, 1024*1024); nil - выделит гигабайт
  выделилось 1048772 кБ в binary alloc (1024.191 мБ)

  """

  def new(element_size, element_count) when is_number(element_size) and is_number(element_count),
    do: UtilsNif.make_binary(element_size * element_count)
  def new(binary_element, element_count) when is_binary(binary_element) and is_number(element_count),
    do: :binary.copy(binary_element, element_count)

  def get(<<bin :: binary>>, element_size, position) do
    bin_size = byte_size(bin)
    head_size = position * element_size
    tail_size = bin_size - head_size - element_size

    << _head :: bytes-size(head_size),
       element :: bytes-size(element_size),
       _tail :: bytes-size(tail_size) >> = bin

    element
  end

  def set(<<bin :: binary>>, <<element :: binary>>, position) do
    bin_size = byte_size(bin)
    element_size = byte_size(element)
    head_size = position * element_size
    tail_size = bin_size - head_size - element_size

    << head :: bytes-size(head_size),
       _old_element :: bytes-size(element_size),
       tail :: bytes-size(tail_size) >> = bin

    head <> element <> tail
  end

end
