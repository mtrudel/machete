defmodule Machete.LiteralMapMatcher do
  @moduledoc false

  # This module defines Machete.Matchable protocol conformance for literal maps. Matching is
  # determined based on whether or not the maps have the same set of keys, and whether or not each
  # pair of elements of the maps matches based on the Machete.Matchable protocol.

  import Machete.Mismatch
  import Machete.Operators

  defimpl Machete.Matchable, for: Map do
    def mismatches(%{}, b) when is_struct(b), do: mismatch("Can't match a map to a struct")

    def mismatches(%{} = a, %{} = b) do
      mismatched_keys(a, b) ++ mismatched_values(a, b)
    end

    def mismatches(%{}, _), do: mismatch("Value is not a map")

    defp mismatched_keys(a, b) do
      a_keys = a |> Map.keys() |> MapSet.new()
      b_keys = b |> Map.keys() |> MapSet.new()

      extra_keys =
        MapSet.difference(b_keys, a_keys)
        |> Enum.flat_map(&mismatch("Unexpected key", &1))

      missing_keys =
        MapSet.difference(a_keys, b_keys)
        |> Enum.flat_map(&mismatch("Missing key", &1))

      extra_keys ++ missing_keys
    end

    defp mismatched_values(a, b) do
      Enum.flat_map(b, fn
        {k, v} when is_map_key(a, k) -> Enum.map(v ~>> a[k], &%{&1 | path: [k | &1.path]})
        _ -> []
      end)
    end
  end
end
