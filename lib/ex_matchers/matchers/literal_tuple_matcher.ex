defmodule ExMatchers.LiteralTupleMatcher do
  @moduledoc """
  This module defines ExMatchers.Matchable protocol conformance for literal tuples. Matching is 
  determined based on whether or not the tuples are the same size, and whether or not each pair of
  elements of the tuples matches based on the ExMatchers.Matchable protocol.
  """

  defimpl ExMatchers.Matchable, for: Tuple do
    def matches?(a, b) when is_tuple(a) and is_tuple(b) do
      matching_length?(a, b) && matching_values?(a, b)
    end

    def matches?(_, _), do: false

    defp matching_length?(a, b), do: tuple_size(a) == tuple_size(b)

    defp matching_values?(a, b) do
      [Tuple.to_list(a), Tuple.to_list(b)]
      |> Enum.zip()
      |> Enum.all?(fn {a, b} ->
        ExMatchers.Matchable.matches?(a, b)
      end)
    end
  end
end
