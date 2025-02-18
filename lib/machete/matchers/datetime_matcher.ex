defmodule Machete.DateTimeMatcher do
  @moduledoc """
  Defines a matcher that matches DateTime values
  """

  import Machete.Mismatch

  defstruct precision: nil,
            time_zone: nil,
            exactly: nil,
            roughly: nil,
            epsilon: nil,
            before: nil,
            after: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @typedoc """
  Describes the arguments that can be passed to this matcher
  """
  @type opts :: [
          {:precision, 0..6},
          {:time_zone, Calendar.time_zone() | :utc},
          {:exactly, DateTime.t()},
          {:roughly, DateTime.t() | :now},
          {:epsilon, integer() | {integer(), integer()}},
          {:before, DateTime.t() | :now},
          {:after, DateTime.t() | :now}
        ]

  @doc """
  Matches against DateTime values

  Takes the following arguments:

  * `precision`: Requires the matched DateTime to have the specified microsecond precision
  * `time_zone`: Requires the matched DateTime to have the specified time zone. The atom `:utc`
    can be used to specify the "Etc/UTC" time zone
  * `exactly`: Requires the matched DateTime to be exactly equal to the specified DateTime
  * `roughly`: Requires the matched DateTime to be within `epsilon` seconds of the specified DateTime.
    The atom `:now` can be used to use the current time as the specified DateTime
  * `epsilon`: The bound(s) to use when determining how close (in microseconds) the matched
    DateTime time needs to be to `roughly`. Can be specified as a single integer that is used for both lower
    and upper bounds, or a tuple consisting of distinct lower and upper bounds. If not specified,
    defaults to 10_000_000 microseconds (10 seconds)
  * `before`: Requires the matched DateTime to be before or equal to the specified DateTime. The
    atom `:now` can be used to use the current time as the specified DateTime
  * `after`: Requires the matched DateTime to be after or equal to the specified DateTime. The
    atom `:now` can be used to use the current time as the specified DateTime

  Examples:

      iex> assert DateTime.utc_now() ~> datetime()
      true

      iex> assert DateTime.utc_now() ~> datetime(precision: 6)
      true

      iex> assert DateTime.utc_now() ~> datetime(time_zone: :utc)
      true

      iex> assert DateTime.utc_now() ~> datetime(time_zone: "Etc/UTC")
      true

      iex> assert ~U[2020-01-01 00:00:00.000000Z] ~> datetime(exactly: ~U[2020-01-01 00:00:00.000000Z])
      true

      iex> assert DateTime.utc_now() ~> datetime(roughly: :now)
      true

      iex> assert ~U[2020-01-01 00:00:00.000000Z] ~> datetime(roughly: ~U[2020-01-01 00:00:05.000000Z])
      true

      iex> assert ~U[2020-01-01 00:00:00.000000Z] ~> datetime(roughly: ~U[2020-01-01 00:00:10.000000Z], epsilon: 10000000)
      true

      iex> assert ~U[2020-01-01 00:00:00.000000Z] ~> datetime(roughly: ~U[2020-01-01 00:00:10.000000Z], epsilon: {10000000, 5000000})
      true

      iex> refute ~U[2020-01-01 00:00:00.000000Z] ~> datetime(roughly: ~U[2020-01-01 00:00:10.000001Z], epsilon: 10000000)
      false

      iex> refute ~U[2020-01-01 00:00:00.000000Z] ~> datetime(roughly: ~U[2020-01-01 00:00:10.000001Z], epsilon: {10000000, 5000000})
      false

      iex> assert ~U[2020-01-01 00:00:00.000000Z] ~> datetime(before: :now)
      true

      iex> assert ~U[2020-01-01 00:00:00.000000Z] ~> datetime(before: ~U[3000-01-01 00:00:00.000000Z])
      true

      iex> assert ~U[3000-01-01 00:00:00.000000Z] ~> datetime(after: :now)
      true

      iex> assert ~U[3000-01-01 00:00:00.000000Z] ~> datetime(after: ~U[2020-01-01 00:00:00.000000Z])
      true
  """
  @spec datetime(opts()) :: t()
  def datetime(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_precision(b, a.precision),
           nil <- matches_time_zone(b, a.time_zone),
           nil <- matches_exactly(b, a.exactly),
           nil <- matches_roughly(b, a.roughly, a.epsilon),
           nil <- matches_before(b, a.before),
           nil <- matches_after(b, a.after) do
      end
    end

    defp matches_type(%DateTime{}), do: nil
    defp matches_type(b), do: mismatch("#{safe_inspect(b)} is not a DateTime")

    defp matches_precision(_, nil), do: nil
    defp matches_precision(%DateTime{microsecond: {_, precision}}, precision), do: nil

    defp matches_precision(%DateTime{microsecond: {_, b_precision}} = b, precision),
      do: mismatch("#{safe_inspect(b)} has precision #{b_precision}, expected #{precision}")

    defp matches_time_zone(_, nil), do: nil
    defp matches_time_zone(b, :utc), do: matches_time_zone(b, "Etc/UTC")
    defp matches_time_zone(%DateTime{time_zone: time_zone}, time_zone), do: nil

    defp matches_time_zone(b, time_zone),
      do: mismatch("#{safe_inspect(b)} has time zone #{b.time_zone}, expected #{time_zone}")

    defp matches_exactly(_, nil), do: nil

    defp matches_exactly(b, exactly) do
      if DateTime.diff(b, exactly, :microsecond) != 0 do
        mismatch("#{safe_inspect(b)} is not equal to #{safe_inspect(exactly)}")
      end
    end

    defp matches_roughly(b, :now, epsilon), do: matches_roughly(b, DateTime.utc_now(), epsilon)

    defp matches_roughly(b, %DateTime{} = roughly, epsilon) do
      range = -lower_bound(epsilon)..upper_bound(epsilon)

      if DateTime.diff(b, roughly, :microsecond) not in range do
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
    defp matches_before(b, :now), do: matches_before(b, DateTime.utc_now())

    defp matches_before(b, before) do
      if DateTime.compare(b, before) != :lt do
        mismatch("#{safe_inspect(b)} is not before #{safe_inspect(before)}")
      end
    end

    defp matches_after(_, nil), do: nil
    defp matches_after(b, :now), do: matches_after(b, DateTime.utc_now())

    defp matches_after(b, after_var) do
      if DateTime.compare(b, after_var) != :gt do
        mismatch("#{safe_inspect(b)} is not after #{safe_inspect(after_var)}")
      end
    end
  end
end
