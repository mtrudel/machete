defmodule ExMatchers.TimeMatcher do
  defstruct precision: nil

  def time(opts \\ []) do
    %__MODULE__{
      precision: Keyword.get(opts, :precision)
    }
  end

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.TimeMatcher{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_precision(b, a.precision) do
      end
    end

    defp matches_type(%Time{}), do: nil
    defp matches_type(b), do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a Time"}]

    defp matches_precision(_, nil), do: nil
    defp matches_precision(%{microsecond: {_, precision}}, precision), do: nil
    defp matches_precision(_, _), do: [%ExMatchers.Mismatch{message: "Precision does not match"}]
  end
end
