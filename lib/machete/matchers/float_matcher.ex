defmodule Machete.FloatMatcher do
  @moduledoc """
  Defines a matcher that matches float values
  """

  import Machete.Mismatch

  defstruct positive: nil, negative: nil, nonzero: nil, min: nil, max: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:positive, boolean()},
          {:negative, boolean()},
          {:nonzero, boolean()},
          {:min, float()},
          {:max, float()}
        ]

  @doc """
  Matches against float values

  Takes the following arguments:

  * `positive`: When `true`, requires the matched float be positive or zero
  * `negative`: When `true`, requires the matched float be negative or zero
  * `nonzero`: When `true`, requires the matched float be nonzero
  * `min`: Requires the matched float be greater than or equal to the specified value
  * `max`: Requires the matched float be less than or equal to the specified value

  Examples:

      iex> assert 1.0 ~> float()
      true

      iex> assert 1.0 ~> float(positive: true)
      true

      iex> assert 0.0 ~> float(positive: true)
      true

      iex> assert -1.0 ~> float(positive: false)
      true

      iex> refute 0.0 ~> float(positive: false)
      false

      iex> assert -1.0 ~> float(negative: true)
      true

      iex> assert 0.0 ~> float(negative: true)
      true

      iex> assert 1.0 ~> float(negative: false)
      true

      iex> refute 0.0 ~> float(negative: false)
      false

      iex> assert 1.0 ~> float(nonzero: true)
      true

      iex> assert 0.0 ~> float(nonzero: false)
      true

      iex> assert 2.0 ~> float(min: 2.0)
      true

      iex> assert 2.0 ~> float(max: 2.0)
      true
  """
  @spec float(opts()) :: t()
  def float(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_positive(b, a.positive),
           nil <- matches_negative(b, a.negative),
           nil <- matches_nonzero(b, a.nonzero),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max) do
      end
    end

    defp matches_type(b) when not is_float(b), do: mismatch("#{inspect(b)} is not a float")
    defp matches_type(_), do: nil

    defp matches_positive(b, true) when b < 0.0, do: mismatch("#{inspect(b)} is not positive")
    defp matches_positive(b, false) when b >= 0.0, do: mismatch("#{inspect(b)} is positive")
    defp matches_positive(_, _), do: nil

    defp matches_negative(b, true) when b > 0.0, do: mismatch("#{inspect(b)} is not negative")
    defp matches_negative(b, false) when b <= 0.0, do: mismatch("#{inspect(b)} is negative")
    defp matches_negative(_, _), do: nil

    defp matches_nonzero(b, true) when b == 0.0, do: mismatch("#{inspect(b)} is zero")
    defp matches_nonzero(b, false) when b != 0.0, do: mismatch("#{inspect(b)} is not zero")
    defp matches_nonzero(_, _), do: nil

    defp matches_min(b, min) when is_float(min) and b < min,
      do: mismatch("#{inspect(b)} is less than #{min}")

    defp matches_min(_, _), do: nil

    defp matches_max(b, max) when is_float(max) and b > max,
      do: mismatch("#{inspect(b)} is greater than #{max}")

    defp matches_max(_, _), do: nil
  end
end
