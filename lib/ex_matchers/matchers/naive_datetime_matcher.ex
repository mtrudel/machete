defmodule ExMatchers.NaiveDateTimeMatcher do
  defstruct precision: nil

  def new(opts \\ []) do
    %__MODULE__{
      precision: Keyword.get(opts, :precision)
    }
  end

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.NaiveDateTimeMatcher{} = a, b) do
      matches_type(b) ++ matches_precision(b, a.precision)
    end

    defp matches_type(%NaiveDateTime{}), do: []
    defp matches_type(_), do: [%ExMatchers.Mismatch{message: "Not a NaiveDateTime"}]

    defp matches_precision(_, nil), do: []
    defp matches_precision(%{microsecond: {_, precision}}, precision), do: []
    defp matches_precision(_, _), do: [%ExMatchers.Mismatch{message: "Precision does not match"}]
  end
end
