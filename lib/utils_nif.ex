# (c) TenderPro inc., 2018
# https://tender.pro, cf@tender.pro, +7(495)215-14-38
# Authors:
# Alexander Golubov <golubov@tender.pro>

defmodule UtilsNif do
  @on_load :init

  def init() do
    nif_filename =
      :barray
      |> Application.app_dir("priv/utils_nif")
      |> to_charlist()
    
    :ok = :erlang.load_nif(nif_filename, 0)
  end

  def make_binary(size),
    do: make_binary(size)

  def dirty_update_binary(<<bin :: binary>>, <<element :: binary>>, position),
    do: dirty_update_binary(<<bin :: binary>>, <<element :: binary>>, position)

  def update_binary(<<bin :: binary>>, <<element :: binary>>, position),
    do: update_binary(<<bin :: binary>>, <<element :: binary>>, position)

  def get_sub_binary(<<bin :: binary>>, element_size, position),
    do: get_sub_binary(<<bin :: binary>>, element_size, position)

  def res_make(len, width), do: res_make(len, width)

  def res_length(res), do: res_length(res)

  # defp utils(_, _) do
  #   exit(:nif_library_not_loaded)
  # end

end
