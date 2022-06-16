defmodule Machete.LiteralTupleMatcher do
  @moduledoc """
  This module defines Machete.Matchable protocol conformance for literal tuples. Matching is 
  determined based on whether or not the tuples are the same size, and whether or not each pair of
  elements of the tuples matches based on the Machete.Matchable protocol.
  """

  defimpl Machete.Matchable, for: Tuple do
    def mismatches(a, b) when is_tuple(a) and is_tuple(b) and tuple_size(a) == tuple_size(b) do
      [Tuple.to_list(a), Tuple.to_list(b)]
      |> Enum.zip()
      |> Enum.with_index()
      |> Enum.flat_map(fn {{a, b}, idx} ->
        (Machete.Matchable.mismatches(a, b) || [])
        |> Enum.map(&%{&1 | path: ["{#{idx}}" | &1.path]})
      end)
    end

    def mismatches(a, b) when is_tuple(a) and is_tuple(b) do
      [%Machete.Mismatch{message: "Tuple sizes not equal"}]
    end

    def mismatches(a, b) when is_tuple(a) do
      [%Machete.Mismatch{message: "#{inspect(b)} is not a tuple"}]
    end
  end
end
