defmodule Machete.LiteralTupleMatcher do
  @moduledoc false

  # This module defines Machete.Matchable protocol conformance for literal tuples. Matching is
  # determined based on whether or not the tuples are the same size, and whether or not each pair of
  # elements of the tuples matches based on the Machete.Matchable protocol.

  import Machete.Mismatch
  import Machete.Operators

  defimpl Machete.Matchable, for: Tuple do
    def mismatches(a, b) when is_tuple(b) and tuple_size(a) == tuple_size(b) do
      [Tuple.to_list(a), Tuple.to_list(b)]
      |> Enum.zip()
      |> Enum.with_index()
      |> Enum.flat_map(fn {{a, b}, idx} ->
        Enum.map(b ~>> a, &%{&1 | path: ["{#{idx}}" | &1.path]})
      end)
    end

    def mismatches(a, b) when is_tuple(b),
      do: mismatch("Tuple is #{tuple_size(b)} elements in size, expected #{tuple_size(a)}")

    def mismatches(_, _), do: mismatch("Value is not a tuple")
  end
end
