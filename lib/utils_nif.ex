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

  def make_binary(size) do
    make_binary(size)
  end

  defp utils(_, _) do
    exit(:nif_library_not_loaded)
  end

end
