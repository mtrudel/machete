defmodule Machete.Mismatch do
  @moduledoc false

  @type t :: %__MODULE__{
          path: [term()],
          message: String.t()
        }

  defstruct path: [], message: nil

  def mismatch(message, path \\ nil)
  def mismatch(message, nil), do: [%__MODULE__{message: message}]
  def mismatch(message, path), do: [%__MODULE__{message: message, path: [path]}]

  def format_mismatches(mismatches, indent \\ "") do
    mismatches
    |> Enum.map(&format_mismatch/1)
    |> Enum.with_index(1)
    |> Enum.map_join("", fn {msg, idx} -> "#{indent}#{idx}) #{msg}\n" end)
  end

  defp format_mismatch(%__MODULE__{path: []} = mismatch) do
    mismatch.message
  end

  defp format_mismatch(mismatch) do
    ".#{format_path(mismatch.path)}: #{mismatch.message}"
  end

  defp format_path(path) do
    path |> Enum.join(".")
  end
end
