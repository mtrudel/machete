defmodule Machete.DateTimeMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct precision: nil, time_zone: nil, roughly: nil, before: nil, after: nil

  def datetime(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_precision(b, a.precision),
           nil <- matches_time_zone(b, a.time_zone),
           nil <- matches_roughly(b, a.roughly),
           nil <- matches_before(b, a.before),
           nil <- matches_after(b, a.after) do
      end
    end

    defp matches_type(%DateTime{}), do: nil
    defp matches_type(b), do: mismatch("#{inspect(b)} is not a DateTime")

    defp matches_precision(_, nil), do: nil
    defp matches_precision(%DateTime{microsecond: {_, precision}}, precision), do: nil

    defp matches_precision(%DateTime{microsecond: {_, b_precision}} = b, precision),
      do: mismatch("#{inspect(b)} has precision #{b_precision}, expected #{precision}")

    defp matches_time_zone(_, nil), do: nil
    defp matches_time_zone(b, :utc), do: matches_time_zone(b, "Etc/UTC")
    defp matches_time_zone(%DateTime{time_zone: time_zone}, time_zone), do: nil

    defp matches_time_zone(b, time_zone),
      do: mismatch("#{inspect(b)} has time zone #{b.time_zone}, expected #{time_zone}")

    defp matches_roughly(_, nil), do: nil
    defp matches_roughly(b, :now), do: matches_roughly(b, DateTime.utc_now())

    defp matches_roughly(b, roughly) do
      if DateTime.diff(b, roughly, :microsecond) not in -10_000_000..10_000_000 do
        mismatch("#{inspect(b)} is not within 10 seconds of #{inspect(roughly)}")
      end
    end

    defp matches_before(_, nil), do: nil
    defp matches_before(b, :now), do: matches_before(b, DateTime.utc_now())

    defp matches_before(b, before) do
      if DateTime.compare(b, before) != :lt do
        mismatch("#{inspect(b)} is not before #{inspect(before)}")
      end
    end

    defp matches_after(_, nil), do: nil
    defp matches_after(b, :now), do: matches_after(b, DateTime.utc_now())

    defp matches_after(b, after_var) do
      if DateTime.compare(b, after_var) != :gt do
        mismatch("#{inspect(b)} is not after #{inspect(after_var)}")
      end
    end
  end
end
