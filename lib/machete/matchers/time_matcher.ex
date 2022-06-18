defmodule Machete.TimeMatcher do
  @moduledoc false

  defstruct precision: nil, roughly: nil, before: nil, after: nil

  def time(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_precision(b, a.precision),
           nil <- matches_roughly(b, a.roughly),
           nil <- matches_before(b, a.before),
           nil <- matches_after(b, a.after) do
      end
    end

    defp matches_type(%Time{}), do: nil
    defp matches_type(b), do: [%Machete.Mismatch{message: "#{inspect(b)} is not a Time"}]

    defp matches_precision(_, nil), do: nil
    defp matches_precision(%Time{microsecond: {_, precision}}, precision), do: nil

    defp matches_precision(%Time{microsecond: {_, b_precision}} = b, precision),
      do: [
        %Machete.Mismatch{
          message: "#{inspect(b)} has precision #{b_precision}, expected #{precision}"
        }
      ]

    defp matches_roughly(_, nil), do: nil
    defp matches_roughly(b, :now), do: matches_roughly(b, Time.utc_now())

    defp matches_roughly(b, roughly) do
      if Time.diff(b, roughly, :microsecond) not in -10_000_000..10_000_000 do
        [
          %Machete.Mismatch{
            message: "#{inspect(b)} is not within 10 seconds of #{inspect(roughly)}"
          }
        ]
      end
    end

    defp matches_before(_, nil), do: nil
    defp matches_before(b, :now), do: matches_before(b, Time.utc_now())

    defp matches_before(b, before) do
      if Time.compare(b, before) != :lt do
        [
          %Machete.Mismatch{
            message: "#{inspect(b)} is not before #{inspect(before)}"
          }
        ]
      end
    end

    defp matches_after(_, nil), do: nil
    defp matches_after(b, :now), do: matches_after(b, Time.utc_now())

    defp matches_after(b, after_var) do
      if Time.compare(b, after_var) != :gt do
        [
          %Machete.Mismatch{
            message: "#{inspect(b)} is not after #{inspect(after_var)}"
          }
        ]
      end
    end
  end
end
