defmodule ExMatchers.LiteralMapMatcher do
  @moduledoc """
  This module defines ExMatchers.Matchable protocol conformance for literal maps. Matching is 
  determined based on whether or not the maps have the same set of keys, and whether or not each 
  pair of elements of the maps matches based on the ExMatchers.Matchable protocol.
  """

  defimpl ExMatchers.Matchable, for: Map do
    def mismatches(%{} = a, %{} = b) do
      mismatched_keys(a, b) ++ mismatched_values(a, b)
    end

    def mismatches(%{}, _), do: [%ExMatchers.Mismatch{message: "Not a map"}]

    defp mismatched_keys(a, b) do
      a_keys = a |> Map.keys() |> MapSet.new()
      b_keys = b |> Map.keys() |> MapSet.new()

      extra_keys =
        MapSet.difference(b_keys, a_keys)
        |> Enum.map(&%ExMatchers.Mismatch{message: "Unexpected key", path: [&1]})

      missing_keys =
        MapSet.difference(a_keys, b_keys)
        |> Enum.map(&%ExMatchers.Mismatch{message: "Missing key", path: [&1]})

      extra_keys ++ missing_keys
    end

    defp mismatched_values(a, b) do
      Enum.flat_map(b, fn {k, v} ->
        if Map.has_key?(a, k) do
          ExMatchers.Matchable.mismatches(a[k], v)
          |> Enum.map(&%{&1 | path: [k | &1.path]})
        else
          []
        end
      end)
    end
  end
end
