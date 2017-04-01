defmodule ElixirMax72xxTest do
  use ExUnit.Case, async: true

  doctest ElixirMax72xx

  test "start_link starts a GenServer and init its state" do
    assert {:ok, pid} = ElixirMax72xx.start_link("spidev0.0")
    assert Process.alive?(pid)
  end
end
