defmodule ExMatchers.LiteralTupleMatcher do
  @moduledoc """
  This module defines ExMatchers.Matchable protocol conformance for literal tuples. Matching is 
  determined based on whether or not the tuples are the same size, and whether or not each pair of
  elements of the tuples matches based on the ExMatchers.Matchable protocol.
  """

  defimpl ExMatchers.Matchable, for: Tuple do
    def mismatches(a, b) when is_tuple(a) and is_tuple(b) and tuple_size(a) == tuple_size(b) do
      [Tuple.to_list(a), Tuple.to_list(b)]
      |> Enum.zip()
      |> Enum.with_index()
      |> Enum.flat_map(fn {{a, b}, idx} ->
        ExMatchers.Matchable.mismatches(a, b)
        |> Enum.map(&%{&1 | path: ["{#{idx}}" | &1.path]})
      end)
    end

    def mismatches(a, b) when is_tuple(a) and is_tuple(b) do
      [%ExMatchers.Mismatch{message: "Tuple sizes not equal"}]
    end

    def mismatches(a, b) when is_tuple(a) do
      [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a tuple"}]
    end
  end
end
