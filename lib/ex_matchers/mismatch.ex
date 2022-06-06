defmodule ExMatchers.Mismatch do
  @type t :: %__MODULE__{
          path: [term()],
          message: String.t()
        }

  defstruct path: [], message: nil

  def format_mismatches(mismatches, indent \\ "") do
    mismatches
    |> Enum.map(&format_mismatch/1)
    |> Enum.with_index(1)
    |> Enum.map(fn {msg, idx} -> "#{indent}#{idx}) #{msg}\n" end)
    |> Enum.join("")
  end

  defp format_mismatch(%ExMatchers.Mismatch{path: []} = mismatch) do
    mismatch.message
  end

  defp format_mismatch(mismatch) do
    ".#{format_path(mismatch.path)}: #{mismatch.message}"
  end

  defp format_path(path) do
    path |> Enum.join(".")
  end
end
