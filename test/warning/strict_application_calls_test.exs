defmodule SlerpChecks.Warning.StrictApplicationCallcsTest do
  @moduledoc false
  use Credo.Test.Case
  alias SlerpChecks.Warning.StrictApplicationCalls

  test "it passes non-compiled files" do
    expected_triggers = [
      "Application.compile_env",
      "Application.fetch_env",
      "Application.get_env"
    ]

    """
    defmodule App do
      @test Application.compile_env(:test, :test)
      @pass Application.compile_env!(:test, :test)

      def test do
        test = Application.fetch_env(:test, :test)
        test
      end

      def test_two do
        Application.get_env(:test, :test)
      end

      def pass do
        Application.fetch_env!(:test, :test)
      end
    end
    """
    |> to_source_file("test.ex")
    |> run_check(StrictApplicationCalls)
    |> assert_issues(fn issues ->
      assert Enum.count(issues) == 3
      assert Enum.map(issues, & &1.trigger) -- expected_triggers == []
    end)
  end
end
