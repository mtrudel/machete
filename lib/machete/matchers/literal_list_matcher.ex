defmodule Machete.LiteralListMatcher do
  @moduledoc """
  This module defines Machete.Matchable protocol conformance for literal lists. Matching is 
  determined based on whether or not the lists are the same size, and whether or not each pair of
  elements of the lists matches based on the Machete.Matchable protocol.
  """

  defimpl Machete.Matchable, for: List do
    def mismatches(a, b) when is_list(a) and is_list(b) and length(a) == length(b) do
      [a, b]
      |> Enum.zip()
      |> Enum.with_index()
      |> Enum.flat_map(fn {{a, b}, idx} ->
        (Machete.Matchable.mismatches(a, b) || [])
        |> Enum.map(&%{&1 | path: ["[#{idx}]" | &1.path]})
      end)
    end

    def mismatches(a, b) when is_list(a) and is_list(b) do
      [%Machete.Mismatch{message: "List lengths not equal"}]
    end

    def mismatches(a, b) when is_list(a) do
      [%Machete.Mismatch{message: "#{inspect(b)} is not a list"}]
    end
  end
end