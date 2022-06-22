defmodule Machete.MapMatcher do
  @moduledoc """
  Defines a matcher that matches maps
  """

  import Machete.Mismatch

  defstruct keys: nil, values: nil, size: nil, min: nil, max: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:keys, Machete.Matchable.t()},
          {:values, Machete.Matchable.t()},
          {:size, non_neg_integer()},
          {:min, non_neg_integer()},
          {:max, non_neg_integer()}
        ]

  @doc """
  Matches maps. Useful for cases where you wish to match against the general shape / size of
  a map, but cannot match against a literal map (or use the `Machete.Superset` / `Machete.Subset`
  matchers)

  Takes the following arguments:

  * `keys`: A matcher to use against all keys in the map
  * `values`: A matcher to use against all values in the map
  * `size`: Requires the matched map to be exactly the specified size
  * `min`: Requires the matched map to be greater than or equal to the specified size
  * `max`: Requires the matched map to be less than or equal to the specified size

  Examples:

      iex> assert %{a: 1} ~> map()
      true

      iex> assert %{a: 1} ~> map(keys: atom())
      true

      iex> assert %{a: 1} ~> map(values: integer())
      true

      iex> assert %{a: 1} ~> map(size: 1)
      true

      iex> assert %{a: 1} ~> map(min: 1)
      true

      iex> assert %{a: 1} ~> map(max: 2)
      true
  """
  @spec map(opts()) :: t()
  def map(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when not is_map(b), do: mismatch("#{inspect(b)} is not a map")

    def mismatches(%@for{} = a, b) do
      with nil <- matches_size(b, a.size),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max),
           nil <- matches_keys(b, a.keys),
           nil <- matches_values(b, a.values) do
      end
    end

    defp matches_size(b, size) when is_number(size) and map_size(b) != size,
      do: mismatch("#{inspect(b)} is not exactly #{size} pairs in size")

    defp matches_size(_, _), do: nil

    defp matches_min(b, min) when is_number(min) and map_size(b) < min,
      do: mismatch("#{inspect(b)} is less than #{min} pairs in size")

    defp matches_min(_, _), do: nil

    defp matches_max(b, max) when is_number(max) and map_size(b) > max,
      do: mismatch("#{inspect(b)} is greater than #{max} pairs in size")

    defp matches_max(_, _), do: nil

    defp matches_keys(_, nil), do: nil

    defp matches_keys(b, matcher) do
      b
      |> Map.keys()
      |> Enum.flat_map(fn k ->
        (Machete.Matchable.mismatches(matcher, k) || [])
        |> Enum.map(&%{&1 | path: [k | &1.path]})
      end)
    end

    defp matches_values(_, nil), do: nil

    defp matches_values(b, matcher) do
      b
      |> Map.keys()
      |> Enum.flat_map(fn k ->
        (Machete.Matchable.mismatches(matcher, b[k]) || [])
        |> Enum.map(&%{&1 | path: [k | &1.path]})
      end)
    end
  end
end
