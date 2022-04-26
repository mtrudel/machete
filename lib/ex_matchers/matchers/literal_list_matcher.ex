defmodule ExMatchers.LiteralListMatcher do
  @moduledoc """
  This module defines ExMatchers.Matchable protocol conformance for literal lists. Matching is 
  determined based on whether or not the lists are the same size, and whether or not each pair of
  elements of the lists matches based on the ExMatchers.Matchable protocol.
  """

  defimpl ExMatchers.Matchable, for: List do
    def matches?(a, b) when is_list(a) and is_list(b) do
      matching_length?(a, b) && matching_values?(a, b)
    end

    def matches?(_, _), do: false

    defp matching_length?(a, b), do: length(a) == length(b)

    defp matching_values?(a, b) do
      [a, b]
      |> Enum.zip()
      |> Enum.all?(fn {a, b} ->
        ExMatchers.Matchable.matches?(a, b)
      end)
    end
  end
end
