defmodule Fitz.Mixfile do
  use Mix.Project

  def project do
    [
      app: :fitz,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package()
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README"],
      maintainers: ["Romario Fitzgerald"],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.

  defp deps do
    [
      {:flow, "~> 0.13"},
      {:timex, "~> 3.1"},
      {:html_entities, "~> 0.3"},
      {:bcrypt_elixir, "~> 1.0"},
      {:slugify, "~> 1.1"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:combination, "~> 0.0.3"},
      {:barlix, "~> 0.3.3"},
      {:uuid, "~> 1.1"},
      {:qrcode, git: "https://gitlab.com/Pacodastre/qrcode", runtime: false}
      #{:twilex, "~> 0.0.1"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
