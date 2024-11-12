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

      extra_keys = MapSet.difference(b_keys, a_keys)
      missing_keys = MapSet.difference(a_keys, b_keys)

      atom_keys =
        extra_keys
        |> Enum.filter(&(is_atom(&1) && MapSet.member?(missing_keys, to_string(&1))))
        |> MapSet.new()

      string_keys =
        extra_keys
        |> Enum.filter(
          &(is_binary(&1) && MapSet.member?(missing_keys, String.to_existing_atom(&1)))
        )
        |> MapSet.new()

      extra_keys =
        extra_keys
        |> MapSet.difference(atom_keys)
        |> MapSet.difference(string_keys)

      missing_keys =
        missing_keys
        |> MapSet.difference(atom_keys |> Enum.map(&Kernel.to_string/1) |> MapSet.new())
        |> MapSet.difference(string_keys |> Enum.map(&String.to_existing_atom/1) |> MapSet.new())

      Enum.flat_map(extra_keys, &mismatch("Unexpected key", &1)) ++
        Enum.flat_map(missing_keys, &mismatch("Missing key", &1)) ++
        Enum.flat_map(atom_keys, &mismatch("Found atom key, expected string", &1)) ++
        Enum.flat_map(string_keys, &mismatch("Found string key, expected atom", &1))
    end

    defp mismatched_values(a, b) do
      b
      |> Enum.sort()
      |> Enum.flat_map(fn
        {k, v} when is_map_key(a, k) -> Enum.map(v ~>> a[k], &%{&1 | path: [k | &1.path]})
        _ -> []
      end)
    end
  end
end
