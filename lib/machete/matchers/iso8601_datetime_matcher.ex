defmodule Machete.ISO8601DateTimeMatcher do
  @moduledoc """
  Defines a matcher that matches ISO8601 formatted strings
  """

  import Machete.DateTimeMatcher
  import Machete.Mismatch
  import Machete.NaiveDateTimeMatcher
  import Machete.Operators

  defstruct datetime_opts: nil

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
          {:offset_required, boolean()},
          {:exactly, DateTime.t()},
          {:roughly, DateTime.t() | :now},
          {:before, DateTime.t() | :now},
          {:after, DateTime.t() | :now}
        ]

  @doc """
  Matches against ISO8601 formatted strings

  Takes the following arguments:

  * `precision`: Requires the matched ISO8601 string to have the specified microsecond precision
  * `time_zone`: Requires the matched ISO8601 string to have the specified time zone. The atom
    `:utc` can be used to specify the "Etc/UTC" time zone
  * `offset_required`: Requires the matched ISO8601 string to have a timezone. Defaults to true
  * `exactly`: Requires the matched ISO8601 string to be exactly equal to the specified DateTime
  * `roughly`: Requires the matched ISO8601 string to be within +/- 10 seconds of the specified 
    DateTime. This values must be specified as a DateTime. The atom `:now` can be used to use the
    current time as the specified DateTime
  * `before`: Requires the matched ISO8601 string to be before or equal to the specified 
    DateTime. This values must be specified as a DateTime. The atom `:now` can be used to use the
    current time as the specified DateTime
  * `after`: Requires the matched ISO8601 string to be after or equal to the specified DateTime.
    This values must be specified as a DateTime. The atom `:now` can be used to use the current 
    time as the specified DateTime

  Examples:

      iex> assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime()
      true

      iex> assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(precision: 6)
      true

      iex> assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(time_zone: :utc)
      true

      iex> assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(time_zone: "Etc/UTC")
      true

      iex> assert "2020-01-01 00:00:00.000000Z" ~> iso8601_datetime(exactly: ~U[2020-01-01 00:00:00.000000Z])
      true

      iex> assert DateTime.utc_now() |> DateTime.to_iso8601() ~> iso8601_datetime(roughly: :now)
      true

      iex> assert NaiveDateTime.utc_now() |> NaiveDateTime.to_iso8601() ~> iso8601_datetime(roughly: :now, offset_required: false)
      true

      iex> assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(roughly: ~U[2020-01-01 00:00:05.000000Z])
      true

      iex> assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(before: :now)
      true

      iex> assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(before: ~U[3000-01-01 00:00:00.000000Z])
      true

      iex> assert "3000-01-01T00:00:00.000000Z" ~> iso8601_datetime(after: :now)
      true

      iex> assert "3000-01-01T00:00:00.000000Z" ~> iso8601_datetime(after: ~U[2020-01-01 00:00:00.000000Z])
      true
  """
  @spec iso8601_datetime(opts()) :: t()
  def iso8601_datetime(opts \\ []), do: struct!(__MODULE__, datetime_opts: opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) when is_binary(b) do
      with nil <- matches_date_time(b, a.datetime_opts) do
        matches_naive_date_time(b, a.datetime_opts)
      end
    end

    def mismatches(%@for{}, b), do: mismatch("#{inspect(b)} is not a string")

    defp matches_date_time(b, datetime_opts) do
      case DateTime.from_iso8601(b) do
        {:ok, datetime_b, 0} -> datetime_b ~>> datetime(datetime_opts)
        _ -> nil
      end
    end

    defp matches_naive_date_time(b, datetime_opts) do
      {offset_required, datetime_opts} = Keyword.pop(datetime_opts, :offset_required, true)

      case NaiveDateTime.from_iso8601(b) do
        {:ok, naive_datetime_b} ->
          if offset_required do
            mismatch("#{inspect(b)} does not have a time zone offset")
          else
            naive_datetime_b ~>> naive_datetime(datetime_opts)
          end

        _ ->
          mismatch("#{inspect(b)} is not a parseable ISO8601 datetime")
      end
    end
  end
end
