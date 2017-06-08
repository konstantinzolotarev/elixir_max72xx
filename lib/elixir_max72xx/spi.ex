defmodule ElixirMax72xx.SPI do

  use GenServer

  defmacro __using__(_) do
    quote do
      @spi Application.get_env(:elixir_max72xx, :spi, ElixirALE.SPI)
    end
  end

  def start_link(_devname, _spi_opts \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def transfer(_pid, _data) do
    <<0, 0>>
  end

end
