defmodule Machete.FloatMatcher do
  @moduledoc """
  Defines a matcher that matches float values
  """

  import Machete.Mismatch

  defstruct positive: nil,
            strictly_positive: nil,
            negative: nil,
            strictly_negative: nil,
            nonzero: nil,
            min: nil,
            max: nil,
            roughly: nil,
            epsilon: nil

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
          {:min, float()},
          {:max, float()},
          {:roughly, float()},
          {:epsilon, float() | {float(), float()}}
        ]

  @doc """
  Matches against float values

  Takes the following arguments:

  * `positive`: When `true`, requires the matched float be positive or zero
  * `strictly_positive`: When `true`, requires the matched float be positive and nonzero
  * `negative`: When `true`, requires the matched float be negative or zero
  * `strictly_negative`: When `true`, requires the matched float be negative and nonzero
  * `nonzero`: When `true`, requires the matched float be nonzero
  * `min`: Requires the matched float be greater than or equal to the specified value
  * `max`: Requires the matched float be less than or equal to the specified value
  * `roughly`: Requires the matched float be within `epsilon` of the specified value
  * `epsilon`: The bound(s) to use when determining how close the matched integer needs to be to
    `roughly`. Can be specified as a single float that is used for both lower and upper bounds,
    or a tuple consisting of distinct lower and upper bounds. If not specified, and if `roughly`
    is not zero, defaults to 5% of the value

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

      iex> assert 1.0 ~> float(strictly_positive: true)
      true

      iex> refute 0.0 ~> float(strictly_positive: true)
      false

      iex> assert -1.0 ~> float(strictly_positive: false)
      true

      iex> assert 0.0 ~> float(strictly_positive: false)
      true

      iex> assert -1.0 ~> float(negative: true)
      true

      iex> assert 0.0 ~> float(negative: true)
      true

      iex> assert 1.0 ~> float(negative: false)
      true

      iex> refute 0.0 ~> float(negative: false)
      false

      iex> assert -1.0 ~> float(strictly_negative: true)
      true

      iex> refute 0.0 ~> float(strictly_negative: true)
      false

      iex> assert 1.0 ~> float(strictly_negative: false)
      true

      iex> assert 0.0 ~> float(strictly_negative: false)
      true

      iex> assert 1.0 ~> float(nonzero: true)
      true

      iex> assert 0.0 ~> float(nonzero: false)
      true

      iex> assert 2.0 ~> float(min: 2.0)
      true

      iex> assert 2.0 ~> float(max: 2.0)
      true

      iex> assert 95.0 ~> float(roughly: 100.0)
      true

      iex> assert -95.0 ~> float(roughly: -100.0)
      true

      iex> assert 90.0 ~> float(roughly: 100.0, epsilon: 10.0)
      true

      iex> assert -90.0 ~> float(roughly: -100.0, epsilon: 10.0)
      true

      iex> assert 105.0 ~> float(roughly: 100.0, epsilon: {10.0, 5.0})
      true

      iex> assert -110.0 ~> float(roughly: -100.0, epsilon: {10.0, 5.0})
      true

      iex> refute 94.0 ~> float(roughly: 100.0)
      false

      iex> refute 89.0 ~> float(roughly: 100.0, epsilon: 10.0)
      false

      iex> refute 106.0 ~> float(roughly: 100.0, epsilon: {10.0, 5.0})
      false
  """
  @spec float(opts()) :: t()
  def float(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_positive(b, a.positive),
           nil <- matches_strictly_positive(b, a.strictly_positive),
           nil <- matches_negative(b, a.negative),
           nil <- matches_strictly_negative(b, a.strictly_negative),
           nil <- matches_nonzero(b, a.nonzero),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max),
           nil <- matches_roughly(b, a.roughly, a.epsilon) do
      end
    end

    defp matches_type(b) when not is_float(b), do: mismatch("#{safe_inspect(b)} is not a float")
    defp matches_type(_), do: nil

    defp matches_positive(b, true) when b < 0.0,
      do: mismatch("#{safe_inspect(b)} is not positive")

    defp matches_positive(b, false) when b >= 0.0, do: mismatch("#{safe_inspect(b)} is positive")
    defp matches_positive(_, _), do: nil

    defp matches_strictly_positive(b, true) when b <= 0.0,
      do: mismatch("#{safe_inspect(b)} is not strictly positive")

    defp matches_strictly_positive(b, false) when b > 0.0,
      do: mismatch("#{safe_inspect(b)} is strictly positive")

    defp matches_strictly_positive(_, _), do: nil

    defp matches_negative(b, true) when b > 0.0,
      do: mismatch("#{safe_inspect(b)} is not negative")

    defp matches_negative(b, false) when b <= 0.0, do: mismatch("#{safe_inspect(b)} is negative")
    defp matches_negative(_, _), do: nil

    defp matches_strictly_negative(b, true) when b >= 0.0,
      do: mismatch("#{safe_inspect(b)} is not strictly negative")

    defp matches_strictly_negative(b, false) when b < 0.0,
      do: mismatch("#{safe_inspect(b)} is strictly negative")

    defp matches_strictly_negative(_, _), do: nil

    defp matches_nonzero(b, true) when b == 0.0, do: mismatch("#{safe_inspect(b)} is zero")
    defp matches_nonzero(b, false) when b != 0.0, do: mismatch("#{safe_inspect(b)} is not zero")
    defp matches_nonzero(_, _), do: nil

    defp matches_min(b, min) when is_float(min) and b < min,
      do: mismatch("#{safe_inspect(b)} is less than #{min}")

    defp matches_min(_, _), do: nil

    defp matches_max(b, max) when is_float(max) and b > max,
      do: mismatch("#{safe_inspect(b)} is greater than #{max}")

    defp matches_max(_, _), do: nil

    defp matches_roughly(b, roughly, epsilon) when is_float(roughly) do
      if roughly - b > lower_bound(roughly, epsilon) or
           b - roughly > upper_bound(roughly, epsilon),
         do: mismatch("#{safe_inspect(b)} is not roughly equal to #{roughly}")
    end

    defp matches_roughly(_, _, _), do: nil

    defp lower_bound(roughly, nil) when roughly in [-0.0, +0.0],
      do: raise("Must specify a value for `epsilon` when `roughly` is 0.0")

    defp lower_bound(roughly, nil), do: abs(round(0.05 * roughly))
    defp lower_bound(_roughly, {lower, _upper}), do: abs(lower)
    defp lower_bound(_roughly, epsilon), do: abs(epsilon)

    defp upper_bound(roughly, nil) when roughly in [-0.0, +0.0],
      do: raise("Must specify a value for `epsilon` when `roughly` is 0")

    defp upper_bound(roughly, nil), do: abs(round(0.05 * roughly))
    defp upper_bound(_roughly, {_lower, upper}), do: abs(upper)
    defp upper_bound(_roughly, epsilon), do: abs(epsilon)
  end
end
