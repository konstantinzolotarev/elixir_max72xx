defmodule ElixirMax72xx.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_max72xx,
     version: "0.1.0",
     elixir: "~> 1.4",
     description: description(),
     package: package(),
     docs: [extras: ["README.md"]],
     aliases: ["docs": ["docs", &copy_images/1]],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     deps: deps()]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:prod), do: ["lib"]
  defp elixirc_paths(_), do: ["test/support", "lib"]

  def application do
    []
  end

  defp description do
    """
    Hex package to use 8x8 LED matrix or 7-segment displays with MAX72XX microchip
    in Elixir/Nerves projects.
    Uses elixir_ale SPI protocol for communication
    """
  end

  defp deps do
    [
      {:elixir_ale, "~> 0.6.1"},
      {:ex_doc, "~> 0.11", only: [:dev]}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Konstantin Zolotarev"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/konstantinzolotarev/elixir_max72xx"}
    ]
  end

  # Copy the images referenced by docs, since ex_doc doesn't do this.
  defp copy_images(_) do
    File.cp_r "assets", "doc/assets"
  end
end
