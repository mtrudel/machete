defmodule Machete.IntegerMatcher do
  @moduledoc """
  Defines a matcher that matches integer values
  """

  import Machete.Mismatch

  defstruct positive: nil,
            strictly_positive: nil,
            negative: nil,
            strictly_negative: nil,
            nonzero: nil,
            min: nil,
            max: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:positive, boolean()},
          {:strictly_positive, boolean()},
          {:negative, boolean()},
          {:strictly_negative, boolean()},
          {:nonzero, boolean()},
          {:min, integer()},
          {:max, integer()}
        ]

  @doc """
  Matches against integer values

  Takes the following arguments:

  * `positive`: When `true`, requires the matched integer be positive or zero
  * `strictly_positive`: When `true`, requires the matched integer be positive and nonzero
  * `negative`: When `true`, requires the matched integer be negative or zero
  * `strictly_negative`: When `true`, requires the matched integer be negative and nonzero
  * `nonzero`: When `true`, requires the matched integer be nonzero
  * `min`: Requires the matched integer be greater than or equal to the specified value
  * `max`: Requires the matched integer be less than or equal to the specified value

  Examples:

      iex> assert 1 ~> integer()
      true

      iex> assert 1 ~> integer(positive: true)
      true

      iex> assert 0 ~> integer(positive: true)
      true

      iex> assert -1 ~> integer(positive: false)
      true

      iex> refute 0 ~> integer(positive: false)
      false

      iex> assert 1 ~> integer(strictly_positive: true)
      true

      iex> refute 0 ~> integer(strictly_positive: true)
      false

      iex> assert -1 ~> integer(strictly_positive: false)
      true

      iex> assert 0 ~> integer(strictly_positive: false)
      true

      iex> assert -1 ~> integer(negative: true)
      true

      iex> assert 0 ~> integer(negative: true)
      true

      iex> assert 1 ~> integer(negative: false)
      true

      iex> refute 0 ~> integer(negative: false)
      false

      iex> assert -1 ~> integer(strictly_negative: true)
      true

      iex> refute 0 ~> integer(strictly_negative: true)
      false

      iex> assert 1 ~> integer(strictly_negative: false)
      true

      iex> assert 0 ~> integer(strictly_negative: false)
      true

      iex> assert 1 ~> integer(nonzero: true)
      true

      iex> assert 0 ~> integer(nonzero: false)
      true

      iex> assert 2 ~> integer(min: 2)
      true

      iex> assert 2 ~> integer(max: 2)
      true
  """
  @spec integer(opts()) :: t()
  def integer(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_positive(b, a.positive),
           nil <- matches_strictly_positive(b, a.strictly_positive),
           nil <- matches_negative(b, a.negative),
           nil <- matches_strictly_negative(b, a.strictly_negative),
           nil <- matches_nonzero(b, a.nonzero),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max) do
      end
    end

    defp matches_type(b) when not is_integer(b),
      do: mismatch("#{safe_inspect(b)} is not an integer")

    defp matches_type(_), do: nil

    defp matches_positive(b, true) when b < 0, do: mismatch("#{safe_inspect(b)} is not positive")
    defp matches_positive(b, false) when b >= 0, do: mismatch("#{safe_inspect(b)} is positive")
    defp matches_positive(_, _), do: nil

    defp matches_strictly_positive(b, true) when b <= 0,
      do: mismatch("#{safe_inspect(b)} is not strictly positive")

    defp matches_strictly_positive(b, false) when b > 0,
      do: mismatch("#{safe_inspect(b)} is strictly positive")

    defp matches_strictly_positive(_, _), do: nil

    defp matches_negative(b, true) when b > 0, do: mismatch("#{safe_inspect(b)} is not negative")
    defp matches_negative(b, false) when b <= 0, do: mismatch("#{safe_inspect(b)} is negative")
    defp matches_negative(_, _), do: nil

    defp matches_strictly_negative(b, true) when b >= 0,
      do: mismatch("#{safe_inspect(b)} is not strictly negative")

    defp matches_strictly_negative(b, false) when b < 0,
      do: mismatch("#{safe_inspect(b)} is strictly negative")

    defp matches_strictly_negative(_, _), do: nil

    defp matches_nonzero(b, true) when b == 0, do: mismatch("#{safe_inspect(b)} is zero")
    defp matches_nonzero(b, false) when b != 0, do: mismatch("#{safe_inspect(b)} is not zero")
    defp matches_nonzero(_, _), do: nil

    defp matches_min(b, min) when is_integer(min) and b < min,
      do: mismatch("#{safe_inspect(b)} is less than #{min}")

    defp matches_min(_, _), do: nil

    defp matches_max(b, max) when is_integer(max) and b > max,
      do: mismatch("#{safe_inspect(b)} is greater than #{max}")

    defp matches_max(_, _), do: nil
  end
end
