defmodule ExMatchers.DateTimeMatcher do
  defstruct precision: nil

  def datetime(opts \\ []) do
    %__MODULE__{
      precision: Keyword.get(opts, :precision)
    }
  end

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.DateTimeMatcher{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_precision(b, a.precision) do
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
  end
end
