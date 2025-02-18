defmodule Machete.NaiveDateTimeMatcher do
  @moduledoc """
  Defines a matcher that matches NaiveDateTime values
  """

  import Machete.Mismatch

  defstruct precision: nil, exactly: nil, roughly: nil, epsilon: nil, before: nil, after: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:precision, 0..6},
          {:exactly, NaiveDateTime.t()},
          {:roughly, NaiveDateTime.t() | :now},
          {:epsilon, integer() | {integer(), integer()}},
          {:before, NaiveDateTime.t() | :now},
          {:after, NaiveDateTime.t() | :now}
        ]

  @doc """
  Matches against NaiveDateTime values

  Takes the following arguments:

  * `precision`: Requires the matched NaiveDateTime to have the specified microsecond precision
  * `exactly`: Requires the matched NaiveDateTime to be exactly equal to the specified NaiveDateTime
  * `roughly`: Requires the matched NaiveDateTime to be within `epsilon` seconds of the specified
     NaiveDateTime. The atom `:now` can be used to use the current time as the specified
     NaiveDateTime
  * `epsilon`: The bound(s) to use when determining how close (in microseconds) the matched
    NaiveDateTime time needs to be to `roughly`. Can be specified as a single integer that is used for both lower
    and upper bounds, or a tuple consisting of distinct lower and upper bounds. If not specified,
    defaults to 10_000_000 microseconds (10 seconds)
  * `before`: Requires the matched NaiveDateTime to be before or equal to the specified
    NaiveDateTime. The atom `:now` can be used to use the current time as the specified
    NaiveDateTime
  * `after`: Requires the matched NaiveDateTime to be after or equal to the specified
    NaiveDateTime. The atom `:now` can be used to use the current time as the specified
    NaiveDateTime

  Examples:

      iex> assert NaiveDateTime.utc_now() ~> naive_datetime()
      true

      iex> assert NaiveDateTime.utc_now() ~> naive_datetime(precision: 6)
      true

      iex> assert ~N[2020-01-01 00:00:00.000000] ~> naive_datetime(exactly: ~N[2020-01-01 00:00:00.000000])
      true

      iex> assert NaiveDateTime.utc_now() ~> naive_datetime(roughly: :now)
      true

      iex> assert ~N[2020-01-01 00:00:00.000000] ~> naive_datetime(roughly: ~N[2020-01-01 00:00:05.000000])
      true

      iex> assert ~N[2020-01-01 00:00:00.000000] ~> naive_datetime(roughly: ~N[2020-01-01 00:00:10.000000], epsilon: 10000000)
      true

      iex> assert ~N[2020-01-01 00:00:00.000000] ~> naive_datetime(roughly: ~N[2020-01-01 00:00:10.000000], epsilon: {10000000, 5000000})
      true

      iex> refute ~N[2020-01-01 00:00:00.000000] ~> naive_datetime(roughly: ~N[2020-01-01 00:00:10.000001], epsilon: 10000000)
      false

      iex> refute ~N[2020-01-01 00:00:00.000000] ~> naive_datetime(roughly: ~N[2020-01-01 00:00:10.000001], epsilon: {10000000, 5000000})
      false

      iex> assert ~N[2020-01-01 00:00:00.000000] ~> naive_datetime(before: :now)
      true

      iex> assert ~N[2020-01-01 00:00:00.000000] ~> naive_datetime(before: ~N[3000-01-01 00:00:00.000000])
      true

      iex> assert ~N[3000-01-01 00:00:00.000000] ~> naive_datetime(after: :now)
      true

      iex> assert ~N[3000-01-01 00:00:00.000000] ~> naive_datetime(after: ~N[2020-01-01 00:00:00.000000])
      true
  """
  @spec naive_datetime(opts()) :: t()
  def naive_datetime(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_precision(b, a.precision),
           nil <- matches_exactly(b, a.exactly),
           nil <- matches_roughly(b, a.roughly, a.epsilon),
           nil <- matches_before(b, a.before),
           nil <- matches_after(b, a.after) do
      end
    end

    defp matches_type(%NaiveDateTime{}), do: nil
    defp matches_type(b), do: mismatch("#{safe_inspect(b)} is not a NaiveDateTime")

    defp matches_precision(_, nil), do: nil
    defp matches_precision(%NaiveDateTime{microsecond: {_, precision}}, precision), do: nil

    defp matches_precision(%NaiveDateTime{microsecond: {_, b_precision}} = b, precision),
      do: mismatch("#{safe_inspect(b)} has precision #{b_precision}, expected #{precision}")

    defp matches_exactly(_, nil), do: nil

    defp matches_exactly(b, exactly) do
      if NaiveDateTime.diff(b, exactly, :microsecond) != 0 do
        mismatch("#{safe_inspect(b)} is not equal to #{safe_inspect(exactly)}")
      end
    end

    defp matches_roughly(b, :now, epsilon),
      do: matches_roughly(b, NaiveDateTime.utc_now(), epsilon)

    defp matches_roughly(b, %NaiveDateTime{} = roughly, epsilon) do
      range = -lower_bound(epsilon)..upper_bound(epsilon)

      if NaiveDateTime.diff(b, roughly, :microsecond) not in range do
        mismatch("#{safe_inspect(b)} is not roughly equal to #{safe_inspect(roughly)}")
      end
    end

    defp matches_roughly(_, _, _), do: nil

    defp lower_bound(nil), do: 10_000_000
    defp lower_bound({lower, _upper}), do: abs(lower)
    defp lower_bound(epsilon), do: abs(epsilon)

    defp upper_bound(nil), do: 10_000_000
    defp upper_bound({_lower, upper}), do: abs(upper)
    defp upper_bound(epsilon), do: abs(epsilon)

    defp matches_before(_, nil), do: nil
    defp matches_before(b, :now), do: matches_before(b, NaiveDateTime.utc_now())

    defp matches_before(b, before) do
      if NaiveDateTime.compare(b, before) != :lt do
        mismatch("#{safe_inspect(b)} is not before #{safe_inspect(before)}")
      end
    end

    defp matches_after(_, nil), do: nil
    defp matches_after(b, :now), do: matches_after(b, NaiveDateTime.utc_now())

    defp matches_after(b, after_var) do
      if NaiveDateTime.compare(b, after_var) != :gt do
        mismatch("#{safe_inspect(b)} is not after #{safe_inspect(after_var)}")
      end
    end
  end
end
