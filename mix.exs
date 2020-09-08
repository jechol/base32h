defmodule Base32H.MixProject do
  use Mix.Project

  def project do
    [
      app: :base32h,
      version: "0.2.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Base32H for Elixir",
      source_url: "https://github.com/jechol/base32h",
      docs: docs()
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jechol/base32h"},
      maintainers: ["Jechol Lee(mr.jechol@gmail.com)"]
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "base32h",
      canonical: "http://hexdocs.pm/base32h",
      source_url: "https://github.com/jechol/base32h",
      extras: [
        "README.md"
      ]
    ]
  end
end
