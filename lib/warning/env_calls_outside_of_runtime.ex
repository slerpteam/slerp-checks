defmodule SlerpChecks.Warning.EnvCallOutsideOfRuntime do
  @moduledoc """
  Checks for System.*_env calls in application code / compile time config, these should go in runtime config instead
  """
  use Credo.Check,
    base_priority: :high,
    category: :warning,
    explanations: [
      check: """
      System.*_env calls should go in runtime config
      """
    ]

  @env_calls [:fetch_env, :fetch_env!, :get_env]

  @impl true
  def run(%SourceFile{filename: filename} = source_file, params) do
    if String.ends_with?(filename, "runtime.exs") do
      []
    else
      issue_meta = IssueMeta.for(source_file, params)
      Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
    end
  end

  defp traverse({:., _, [{:__aliases__, meta, [:System]}, function]} = ast, issues, issue_meta)
       when function in @env_calls do
    {ast, [issue_for(meta, issue_meta, function) | issues]}
  end

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end

  defp issue_for(meta, issue_meta, function) do
    format_issue(
      issue_meta,
      message: "Please access environment variables in runtime config only",
      trigger: "System.#{function}",
      line_no: meta[:line]
    )
  end
end
