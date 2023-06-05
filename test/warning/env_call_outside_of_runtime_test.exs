defmodule SlerpChecks.Warning.EnvCallOutsideOfRuntimeTest do
  @moduledoc false
  use Credo.Test.Case

  alias SlerpChecks.Warning.EnvCallOutsideOfRuntime

  test "it passes runtime.exs" do
    """
    import Config

    config :test, test: System.get_env("TEST")
    """
    |> to_source_file("runtime.exs")
    |> run_check(EnvCallOutsideOfRuntime)
    |> refute_issues()
  end

  test "it fails all other files accessing environment variables" do
    expected_triggers = ["System.get_env", "System.fetch_env", "System.fetch_env!"]

    """
    defmodule App do
      def test do
        System.get_env("TEST")
        System.fetch_env("TEST")
        System.fetch_env!("TEST")
      end
    end
    """
    |> to_source_file("test.ex")
    |> run_check(EnvCallOutsideOfRuntime)
    |> assert_issues(fn issues ->
      assert Enum.count(issues) == 3
      assert Enum.map(issues, & &1.trigger) -- expected_triggers == []
    end)
  end
end
