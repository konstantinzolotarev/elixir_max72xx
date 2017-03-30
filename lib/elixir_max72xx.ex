defmodule ElixirMax72xx do
  @moduledoc """
  `elixir_max72xx` provides high level of abstractions for interfacing to MAX7219/MAX7221
  microchips with LED matrix and 7-segment displays using SPI communication bus
  """

  use GenServer


  @doc """
  Start the ElixirMax72xx GenServer to manage LED matrix

  Parameters:
   * `devname` is the Linux device name for the bus (e.g., "spidev0.0")
   * `opts` is a keyword list to configure the module
  """
  @spec start_link(binary, list) :: {:ok, pid}
  def start_link(devname, opts \\ []) do
    state = []
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc false
  @spec init(term) :: {:ok, term}
  def init(state) do
    # init SPI
    {:ok, state}
  end
  
  @doc """
  Shutdown matrix.

  Example:
  ```elixir
  iex> ElixirMax72xx.shutdown(true)
  :ok
  iex> ElixirMax72xx.shutdown(false)
  ```
  """
  @spec shutdown(boolean) :: :ok
  def shutdown(true), do: cast({:shutdown, 0x00})
  def shutdown(false), do: cast({:shutdown, 0x01})

  @doc """
  Enable/disable matrix test feature.

  Example: 
  ```elixir
  iex> ElixirMax72xx.test(true)
  :ok
  iex> ElixirMax72xx.test(false)
  :ok
  ```
  """
  @spec test(enable :: boolean) :: :ok
  def test(true), do: cast({:test, 0x01})
  def test(false), do: cast({:test, 0x00})

  ##
  #
  # Private methods section
  #
  ##
  defp cast(msg), do: GenServer.cast(__MODULE__, msg)

  defp stop(msg), do: GenServer.stop(__MODULE__, msg)

end
