defmodule ElixirMax72xx do
  @moduledoc """
  `elixir_max72xx` provides high level of abstractions for interfacing to MAX7219/MAX7221
  microchips with LED matrix and 7-segment displays using SPI communication bus
  """

  use GenServer


  @type row_number :: 1..8

  @type row_value :: 0b00000000..0b11111111

  defmodule MatrixState do
    @moduledoc false
    defstruct (
      devname: "spidev0.0",
      leds: [
        0b00000000,
        0b00000000,
        0b00000000,
        0b00000000,
        0b00000000,
        0b00000000,
        0b00000000,
        0b00000000,
      ]
    )
  end


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

  @doc """
  Clear matrix

  Example:
  ```elixir
  iex> ElixirMax72xx.clear()
  :ok
  ```
  """
  @spec clear() :: :ok
  def clear(), do: cast({:clean})

  
  @doc """
  Will clear given row

  Rows could be integers from 1 to 8
  Example:
  ```elixir
  iex> ElixirMax72xx.clear_row(1)
  :ok
  iex> ElixirMax72xx.clear_row(7)
  :ok
  iex> ElixirMax72xx.clear_row(0)
  ** (FunctionClauseError) no function clause matching in ElixirMax72xx.clear_row/1
  ```
  """
  @spec clear_row(row_number) :: :ok
  def clear_row(row) when row in 1..8, do: cast({:clear_row, row})


  @doc """
  Sets row lights

  Parameters:
   * `row` - row number 1..8
   * `value` - value of row lights `0b00110011

  Example:
  ```elixir
  iex> ElixirMax72xx.set_row(1, 0b00001100)
  :ok
  ```
  """
  @spec set_row(row_number, row_value) :: :ok
  def set_row(row, value) when row in 1..8, do: cast({:set_row, row, value})

  ##
  #
  # Private methods section
  #
  ##
  defp cast(msg), do: GenServer.cast(__MODULE__, msg)

  defp stop(msg), do: GenServer.stop(__MODULE__, msg)

end
