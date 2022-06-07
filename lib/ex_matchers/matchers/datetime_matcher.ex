defmodule ExMatchers.DateTimeMatcher do
  defstruct precision: nil, time_zone: nil

  def datetime(opts \\ []) do
    %__MODULE__{
      precision: Keyword.get(opts, :precision),
      time_zone: Keyword.get(opts, :time_zone)
    }
  end

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.DateTimeMatcher{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_precision(b, a.precision),
           nil <- matches_time_zone(b, a.time_zone) do
      end
    end

    defp matches_type(%DateTime{}), do: nil
    defp matches_type(b), do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a DateTime"}]

    defp matches_precision(_, nil), do: nil
    defp matches_precision(%DateTime{microsecond: {_, precision}}, precision), do: nil

    defp matches_precision(%DateTime{microsecond: {_, b_precision}} = b, precision),
      do: [
        %ExMatchers.Mismatch{
          message: "#{inspect(b)} has precision #{b_precision}, expected #{precision}"
        }
      ]

    defp matches_time_zone(_, nil), do: nil
    defp matches_time_zone(b, :utc), do: matches_time_zone(b, "Etc/UTC")
    defp matches_time_zone(%DateTime{time_zone: time_zone}, time_zone), do: nil

    defp matches_time_zone(b, time_zone),
      do: [
        %ExMatchers.Mismatch{
          message: "#{inspect(b)} has time zone #{b.time_zone}, expected #{time_zone}"
        }
      ]
  end
end
