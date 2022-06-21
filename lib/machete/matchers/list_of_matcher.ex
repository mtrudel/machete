defmodule Machete.ListOfMatcher do
  @moduledoc """
  Defines a matcher that matches lists
  """

  import Machete.Mismatch

  defstruct matcher: nil, min: nil, max: nil, length: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:length, non_neg_integer()},
          {:min, non_neg_integer()},
          {:max, non_neg_integer()}
        ]

  @doc """
  Matches lists

  Takes another matcher as its first argument to use when matching against elements in the list.
  Takes an keyword list as an optional second argument with the following valid values:

  * `length`: Requires the matched list to be exactly the specified length
  * `min`: Requires the matched list to be greater than or equal to the specified length
  * `max`: Requires the matched list to be less than or equal to the specified length

  Examples:
      iex> assert [1] ~> list_of(integer())
      true

      iex> assert [1] ~> list_of(integer(), min: 1)
      true

      iex> assert [1] ~> list_of(integer(), max: 2)
      true

      iex> assert [1] ~> list_of(integer(), length: 1)
      true
  """
  @spec list_of(Machete.Matchable.t(), opts()) :: t()

  def list_of(matcher, opts \\ []), do: struct!(__MODULE__, [matcher: matcher] ++ opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when not is_list(b), do: mismatch("#{inspect(b)} is not a list")

    def mismatches(%@for{} = a, b) do
      with nil <- matches_length(b, a.length),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max),
           nil <- matches_matcher(b, a.matcher) do
      end
    end

    defp matches_length(_, nil), do: nil

    defp matches_length(b, length) do
      unless length(b) == length do
        mismatch("#{inspect(b)} is not exactly #{length} elements in length")
      end
    end

    defp matches_min(_, nil), do: nil

    defp matches_min(b, length) do
      unless length(b) >= length do
        mismatch("#{inspect(b)} is less than #{length} elements in length")
      end
    end

    defp matches_max(_, nil), do: nil

    defp matches_max(b, length) do
      unless length(b) <= length do
        mismatch("#{inspect(b)} is more than #{length} elements in length")
      end
    end

    defp matches_matcher(b, matcher) do
      matchers = [matcher] |> Stream.cycle() |> Enum.take(length(b))
      Machete.Matchable.mismatches(matchers, b)
    end
  end
end
