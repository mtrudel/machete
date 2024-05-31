defmodule Machete.ListMatcher do
  @moduledoc """
  Defines a matcher that matches lists
  """

  import Machete.Mismatch
  import Machete.Operators

  defstruct elements: nil, match_mode: :all, length: nil, min: nil, max: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:elements, Machete.Matchable.t()},
          {:match_mode, :all | :any | :none | non_neg_integer()},
          {:length, non_neg_integer()},
          {:min, non_neg_integer()},
          {:max, non_neg_integer()}
        ]

  @doc """
  Matches lists. Useful for cases where you wish to match against the general shape / size of
  a list, but cannot match against a literal list

  Takes the following arguments:

  * `elements`: A matcher to use against all elements in the list
  * `match_mode`: How to apply the `elements` matcher to the elements in the list. `:all`, `:any`,
    and `:none` each match if all, any, or none of the list's elements match the `elements` matcher,
    respectively. A non-negative integer requires at least `n` of the elements in the list to match.
    Defaults to `:all`
  * `length`: Requires the matched list to be exactly the specified length
  * `min`: Requires the matched list to be greater than or equal to the specified length
  * `max`: Requires the matched list to be less than or equal to the specified length

  Examples:
      iex> assert [1] ~> list(elements: integer())
      true

      iex> assert [1, "a", :b] ~> list(elements: integer(), match_mode: :any)
      true

      iex> assert ["a", "b", :c] ~> list(elements: integer(), match_mode: :none)
      true

      iex> assert [1, 2, 3] ~> list(elements: integer(), match_mode: 2)
      true

      iex> assert [1] ~> list(length: 1)
      true

      iex> assert [1] ~> list(min: 1)
      true

      iex> assert [1] ~> list(max: 2)
      true
  """
  @spec list(opts()) :: t()

  def list(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when not is_list(b), do: mismatch("#{inspect(b)} is not a list")

    def mismatches(%@for{} = a, b) do
      with nil <- matches_length(b, a.length),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max),
           nil <- matches_elements(b, a.elements, a.match_mode) do
      end
    end

    defp matches_length(b, length) when is_number(length) and length(b) != length,
      do: mismatch("#{inspect(b)} is not exactly #{length} elements in length")

    defp matches_length(_, _), do: nil

    defp matches_min(b, length) when is_number(length) and length(b) < length,
      do: mismatch("#{inspect(b)} is less than #{length} elements in length")

    defp matches_min(_, _), do: nil

    defp matches_max(b, length) when is_number(length) and length(b) > length,
      do: mismatch("#{inspect(b)} is more than #{length} elements in length")

    defp matches_max(_, _), do: nil

    defp matches_elements(_, nil, _), do: nil
    defp matches_elements(b, matcher, :all), do: b ~>> List.duplicate(matcher, length(b))

    defp matches_elements(b, matcher, :any) do
      num_matches = Enum.count(b, &(&1 ~> matcher))
      if num_matches == 0, do: mismatch("No elements match the specified matcher")
    end

    defp matches_elements(b, matcher, :none) do
      num_matches = Enum.count(b, &(&1 ~> matcher))
      if num_matches != 0, do: mismatch("#{num_matches} element(s) match the specified matcher")
    end

    defp matches_elements(b, matcher, min_matches) when is_integer(min_matches) do
      num_matches = Enum.count(b, &(&1 ~> matcher))

      if num_matches < min_matches,
        do: mismatch("Only #{num_matches} element(s) match the specified matcher")
    end
  end
end
