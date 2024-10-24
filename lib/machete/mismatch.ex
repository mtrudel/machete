defmodule Machete.Mismatch do
  @moduledoc """
  Data and functions to deal with representing mismatches
  """

  @typedoc """
  Describes the details of a mismatch
  """
  @type t :: %__MODULE__{
          path: [term()],
          message: String.t()
        }

  defstruct path: [], message: nil

  @doc """
  Constructs an instance of `Matchable.Mismatch` with the given message and path, wrapped in
  a list and suitable for return from a `Machete.Matchable.mismatches/2` call
  """
  def mismatch(message, path \\ nil)
  def mismatch(message, nil), do: [%__MODULE__{message: message}]
  def mismatch(message, path), do: [%__MODULE__{message: message, path: [path]}]

  @doc """
  Pretty prints the specified list of mismatches, in a manner suitable for presentation to the
  user
  """
  def format_mismatches(mismatches, indent \\ "") do
    mismatches
    |> Enum.map(&format_mismatch/1)
    |> Enum.with_index(1)
    |> Enum.map_join("", fn {msg, idx} -> "#{indent}#{idx}) #{msg}\n" end)
  end

  @doc """
  Helper that inspects the given term ensuring map ordering
  """
  def safe_inspect(term), do: inspect(term, custom_options: [sort_maps: true])

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
