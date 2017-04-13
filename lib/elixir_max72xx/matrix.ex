defmodule ElixirMax72xx.Matrix do

  use ElixirMax72xx.SPI

  @op_noop        0x00
  @op_digit1      0x01
  @op_digit2      0x02
  @op_digit3      0x03
  @op_digit4      0x04
  @op_digit5      0x05
  @op_digit6      0x06
  @op_digit7      0x07
  @op_digit8      0x08
  @op_decodmode   0x09
  @op_intensity   0x0A
  @op_scanlimit   0x0B
  @op_shutdown    0x0C
  @op_displaytest 0x0F

  # State for 8x8 led matrix
  defmodule MatrixState do
    @moduledoc false
    defstruct devname: "spidev0.0",
              pid: nil,
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
  end

  @type row_number :: 1..8

  @type row_value :: 0b00000000..0b11111111

  @type matrix_value :: [row_value]

  @doc """
  Start the ElixirMax72xx GenServer to manage LED matrix

  Parameters:
   * `devname` is the Linux device name for the bus (e.g., "spidev0.0")
   * `opts` is a keyword list to configure the module
  """
  @spec start_link(binary, list) :: {:ok, pid}
  def start_link(devname \\ "spidev0.0", opts \\ []) do
    state = %MatrixState{devname: devname}
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc false
  @spec init(term) :: {:ok, term}
  def init(state) do
    state = start(state)
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
  def shutdown(true), do: call({:shutdown, 0x00})
  def shutdown(false), do: call({:shutdown, 0x01})

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
  def test(true), do: call({:test, 0x01})
  def test(false), do: call({:test, 0x00})

  @doc """
  Clear matrix

  Example:
  ```elixir
  iex> ElixirMax72xx.clear()
  :ok
  ```
  """
  @spec clear() :: :ok
  def clear(), do: call({:clean})

  @doc """
  Set scanlimit for device

  Example:
  ```elixir
  iex> ElixirMax72xx.set_scanlimit(7)
  :ok
  ```
  """
  @spec set_scanlimit(integer) :: :ok
  def set_scanlimit(value), do: call({:set_scanlimit, value})

  @doc """
  Set decode-mode for matrix

  Example:
  ```elixir
  iex> ElixirMax72xx.set_decodemod(0x0F)
  :ok
  ```
  """
  @spec set_decodemod(0x00 | 0x01 | 0x0F | 0xFF) :: :ok
  def set_decodemod(value), do: call({:set_decodemod, value})

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
  def clear_row(row) when row in 1..8, do: call({:clear_row, row})


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
  @spec set_row({row_number, row_value}) :: :ok
  def set_row({row, value}) when row in 1..8, do: call({:set_row, row, value})

  @doc """
  Sets matrix values

  Example:
  ```elixir
  iex(1)> matrix_value = [
  ...(1)> 0b00000000,
  ...(1)> 0b00000000,
  ...(1)> 0b00000000,
  ...(1)> 0b00010000,
  ...(1)> 0b00000000,
  ...(1)> 0b00000000,
  ...(1)> 0b00000000,
  ...(1)> 0b00000000
  ...(1)> ]
  [0, 0, 0, 0, 0, 0, 0, 0]
  iex(2)> ElixirMax72xx.set_matrix(matrix_value)
  :ok
  ```
  """
  @spec set_matrix(matrix_value) :: :ok
  def set_matrix(value), do: call({:set, value})


  @doc """
  Get current state

  Example
  ```elixir
  iex(1)> ElixirMax72xx.Matrix.state()
  %ElixirMax72xx.Matrix.MatrixState{devname: "spidev0.0",
   leds: [0, 0, 0, 0, 0, 0, 0, 0], pid: #PID<0.793.0>}
  ```
  """
  @spec state() :: %MatrixState{}
  def state(), do: call(:state)

  ##
  #
  # Handlers list
  #
  ##
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:shutdown, value}, _from, %{pid: pid} = state) do
    send_command(pid, <<@op_shutdown, value>>)
    {:reply, :ok, state}
  end

  def handle_call({:test, value}, _from, %{pid: pid} = state) do
    send_command(pid, <<@op_displaytest, value>>)
    {:reply, :ok, state}
  end

  def handle_call({:clean}, _from, %{pid: pid} = state) do
    # iterate through rows
    {:reply, :ok, state}
  end

  def handle_call({:set_scanlimit, value}, _from, %{pid: pid} = state) do
    send_command(pid, <<@op_scanlimit, value>>)
    {:reply, :ok, state}
  end

  def handle_call({:set_decodemod, value}, _from, %{pid: pid} = state) do
    send_command(pid, <<@op_decodmode, value>>)
    {:reply, :ok, state}
  end

  def handle_call({:clear_row, row}, _from, %{pid: pid} = state) do
    state = set_row({row, 0b00000000}, state)
    {:reply, :ok, state}
  end

  def handle_call({:set_row, row, value}, _from, state) do
    state = set_row({row, value}, state)
    {:reply, :ok, state}
  end

  def handle_call({:set, value}, _from, state) do
    state = value
    |> Enum.with_index
    |> Enum.each(&set_row(&1, state))

    {:reply, :ok, state}
  end

  ##
  #
  # Private methods section
  #
  ##

  @spec start(MatrixState) :: MatrixState
  defp start(%MatrixState{devname: devname} = state) do
    {:ok, pid} = @spi.start_link(devname)
    %{state | pid: pid}
  end

  @spec send_command(pid, integer) :: integer
  defp send_command(pid, value) do
    @spi.transfer(pid, value)
  end

  defp set_row({row, value}, %{pid: pid} = state) do
    leds = state.leds
      |> List.replace_at(row, value)

    send_command(pid, <<row, value>>)
    %MatrixState{state | leds: leds}
  end

  defp call(msg), do: GenServer.call(__MODULE__, msg)

  defp cast(msg), do: GenServer.cast(__MODULE__, msg)

  defp stop(msg), do: GenServer.stop(__MODULE__, msg)

end
