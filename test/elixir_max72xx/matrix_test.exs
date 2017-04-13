defmodule ElixirMax72xx.MatrixTest do
  use ExUnit.Case

  alias ElixirMax72xx.Matrix

  setup_all do
    {:ok, pid} = Matrix.start_link()
    {:ok, pid: pid}
  end

  test "check state" do
    %{pid: pid} = Matrix.state()
    assert Process.alive?(pid)
  end


end
