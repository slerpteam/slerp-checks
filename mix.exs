defmodule SlerpChecks.MixProject do
  use Mix.Project

  def project do
    [
      app: :slerp_checks,
      version: "0.1.0",
      elixir: ">= 1.10.0",
      start_permanent: false,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7"}
    ]
  end
end
