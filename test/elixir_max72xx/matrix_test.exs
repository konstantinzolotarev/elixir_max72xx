defmodule ElixirMax72xx.MatrixTest do
  use ExUnit.Case, async: false

  alias ElixirMax72xx.Matrix

  @defaultMatrix [
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
  ]

  setup_all do
    {:ok, pid} = Matrix.start_link()
    # {:ok, pid: pid}
    :ok
  end

  setup do
    Matrix.clear()
  end

  test "pid is alive" do
    %{pid: pid} = Matrix.state()
    assert Process.alive?(pid)
  end

  test "matrix leds should be set to default" do
    %{leds: leds} = Matrix.state()
    assert length(leds) == 8
    assert leds == @defaultMatrix
  end

  test "set_row should set row value" do
    row_value = 0b11111111
    Matrix.set_row(1, row_value)
    %{leds: [row | _]} = Matrix.state()
    assert row == row_value
  end

  test "clear_row should clear row" do
    Matrix.clear_row(1)
    %{leds: [row | _]} = Matrix.state()
    assert row == 0b00000000
  end

  test "clear should update all rows" do
    row_value = 0b11111111
    Matrix.set_row(1, row_value)
    %{leds: [row | _]} = Matrix.state()
    assert row == row_value

    Matrix.clear()
    %{leds: leds} = Matrix.state()
    assert leds == @defaultMatrix
  end

  test "set_matrix should update whole matrix" do
    matrix = [
      0b00011000,
      0b00111100,
      0b00011000,
      0b00011000,
      0b00000011,
      0b00000001,
      0b10000000,
      0b01010101,
    ]
    Matrix.set_matrix(matrix)
    %{leds: leds} = Matrix.state()
    assert leds == matrix
  end
end
