defmodule SlerpChecks.Warning.MockCheckTest do
  @moduledoc false

  use Credo.Test.Case

  alias SlerpChecks.Warning.MockCheck

  test "it passes modules not using mock" do
    """
    defmodule App do
      use ExUnit.Case

      test "test" do
        assert true
      end
    end
    """
    |> to_source_file("test_pass.exs")
    |> run_check(MockCheck)
    |> refute_issues()
  end

  test "it fails modules importing mock" do
    """
    defmodule App do
      use ExUnit.Case
      import Mock

      test "test" do
        with_mock(App, [hello: fn -> :world end], fn ->
          assert App.hello() == :world
        end)
      end
    end
    """
    |> to_source_file("test_import.exs")
    |> run_check(MockCheck)
    |> assert_issue(fn issue -> issue.trigger == "Mock" end)
  end

  test "it fails modules using mock without importing" do
    """
    defmodule App do
      use ExUnit.Case

      test "test" do
        Mock.with_mock(App, [hello: fn -> :world end], fn ->
          assert App.hello() == :world
        end)
      end
    end
    """
    |> to_source_file("test_no_import.exs")
    |> run_check(MockCheck)
    |> assert_issue(fn issue -> issue.trigger == "Mock" end)
  end
end
