defmodule ElixirMax72xx.SPI do

  use GenServer

  defmacro __using__(_) do
    quote do
      @spi Application.get_env(:elixir_max72xx, :spi, ElixirALE.SPI)
    end
  end

  def transfer(pid, data) do
    # Something
  end

end
