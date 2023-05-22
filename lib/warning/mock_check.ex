defmodule SlerpChecks.Warning.MockCheck do
  @moduledoc """
  Checks for mock imports or usage
  """
  use Credo.Check,
    base_priority: :high,
    category: :warning,
    explanations: [
      check: """
      Mock prevents us from running tests async, and leads to less strict & accurate tests.
      Please use Hammox instead
      """
    ]

  @impl true
  def run(%SourceFile{filename: filename} = source_file, params) do
    if String.ends_with?(filename, "exs") do
      issue_meta = IssueMeta.for(source_file, params)
      Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
    else
      []
    end
  end

  defp traverse({:__aliases__, meta, [:Mock]} = ast, issues, issue_meta) do
    {ast, [issue_for(meta, issue_meta) | issues]}
  end

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end

  defp issue_for(meta, issue_meta) do
    format_issue(
      issue_meta,
      message: "Please use Hammox instead of Mock",
      trigger: "Mock",
      line_no: meta[:line]
    )
  end
end
