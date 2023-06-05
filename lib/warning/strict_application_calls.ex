defmodule SlerpChecks.Warning.StrictApplicationCalls do
  @moduledoc """
  Checks for Application config calls which don't throw errors
  """

  use Credo.Check,
    base_priority: :high,
    category: :warning,
    explanations: [
      check: """
      Application config calls should throw errors if they fail
      """
    ]

  @application_calls [:compile_env, :fetch_env, :get_env]

  @impl true
  def run(%SourceFile{} = source_file, params) do
    issue_meta = IssueMeta.for(source_file, params)
    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  defp traverse(
         {:., _, [{:__aliases__, meta, [:Application]}, function]} = ast,
         issues,
         issue_meta
       )
       when function in @application_calls do
    {ast, [issue_for(meta, issue_meta, function) | issues]}
  end

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end

  defp issue_for(meta, issue_meta, function) do
    format_issue(
      issue_meta,
      message: get_message(function),
      trigger: "Application.#{function}",
      line_no: meta[:line]
    )
  end

  defp get_message(:compile_env) do
    "Please use Application.compile_env!"
  end

  defp get_message(_) do
    "Please use Application.fetch_env!"
  end
end
