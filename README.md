# ElixirMax72xx

`elixir_max72xx` provides high level of abstractions for interfacing with MAX7219/MAX7221
microchips with LED matrix and 7-segment displays using SPI communication bus.

**Disclaimer**: This is still under heavy development and probably isn't suited for production use.
Please consider testing and contributing to improving the project.

## Documentation
Project and API documentation is available online at [hexdocs.pm](https://hexdocs.pm/elixir_max72xx)

## Installation

`ElixirMax72xx` [available in Hex](https://hexdocs.pm/elixir_max72xx), the package can be installed
by adding `elixir_max72xx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:elixir_max72xx, "~> 0.1.0"}]
end
```

Ensure `elixir_max72xx` is started before your application:
```elixir
def application(_target) do
      [mod: {MyApplication.Application, []},
       extra_applications: [:elixir_max72xx]]
    end
```

## Configuration

**TBD**

## Example

```elixir
alias ElixirMax72xx.Matrix

def some_func do
  Matrix.clear()
  Matrix.set_row(1, 0b00111100)
end
```
