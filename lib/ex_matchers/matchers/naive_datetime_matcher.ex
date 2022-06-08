defmodule ExMatchers.NaiveDateTimeMatcher do
  defstruct precision: nil, roughly: nil, before: nil, after: nil

  def naive_datetime(opts \\ []) do
    %__MODULE__{
      precision: Keyword.get(opts, :precision),
      roughly: Keyword.get(opts, :roughly),
      before: Keyword.get(opts, :before),
      after: Keyword.get(opts, :after)
    }
  end

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.NaiveDateTimeMatcher{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_precision(b, a.precision),
           nil <- matches_roughly(b, a.roughly),
           nil <- matches_before(b, a.before),
           nil <- matches_after(b, a.after) do
      end
    end

    defp matches_type(%NaiveDateTime{}), do: nil

    defp matches_type(b),
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a NaiveDateTime"}]

    defp matches_precision(_, nil), do: nil
    defp matches_precision(%NaiveDateTime{microsecond: {_, precision}}, precision), do: nil

    defp matches_precision(%NaiveDateTime{microsecond: {_, b_precision}} = b, precision),
      do: [
        %ExMatchers.Mismatch{
          message: "#{inspect(b)} has precision #{b_precision}, expected #{precision}"
        }
      ]

    defp matches_roughly(_, nil), do: nil
    defp matches_roughly(b, :now), do: matches_roughly(b, NaiveDateTime.utc_now())

    defp matches_roughly(b, roughly) do
      if NaiveDateTime.diff(b, roughly, :microsecond) not in -10_000_000..10_000_000 do
        [
          %ExMatchers.Mismatch{
            message: "#{inspect(b)} is not within 10 seconds of #{inspect(roughly)}"
          }
        ]
      end
    end

    defp matches_before(_, nil), do: nil
    defp matches_before(b, :now), do: matches_before(b, NaiveDateTime.utc_now())

    defp matches_before(b, before) do
      if NaiveDateTime.compare(b, before) != :lt do
        [
          %ExMatchers.Mismatch{
            message: "#{inspect(b)} is not before #{inspect(before)}"
          }
        ]
      end
    end

    defp matches_after(_, nil), do: nil
    defp matches_after(b, :now), do: matches_after(b, NaiveDateTime.utc_now())

    defp matches_after(b, after_var) do
      if NaiveDateTime.compare(b, after_var) != :gt do
        [
          %ExMatchers.Mismatch{
            message: "#{inspect(b)} is not after #{inspect(after_var)}"
          }
        ]
      end
    end
  end
end
