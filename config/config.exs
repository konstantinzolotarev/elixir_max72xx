# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Sample MAX7219/MAX7221 configuration for 8x8 LED Matrix
# connected to RPI3.
# This library uses SPI protocol for communication to MAX72xx chip
#
# Parameters:
#  * `devname` is the Linux device name for the bus (e.g., "spidev0.0")
#
config :elixir_max72xx, devname: "spidev0.0"

import_config "#{Mix.env}.exs"
