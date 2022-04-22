defmodule ExMatchers.NaiveDateTimeMatcher do
  defstruct precision: nil

  def new(opts \\ []) do
    %__MODULE__{
      precision: Keyword.get(opts, :precision)
    }
  end

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.NaiveDateTimeMatcher{} = a, b) do
      match?(%NaiveDateTime{}, b) && matches_precision?(b, a.precision)
    end

    defp matches_precision?(_, nil), do: true
    defp matches_precision?(%{microsecond: {_, precision}}, precision), do: true
    defp matches_precision?(_, _), do: false
  end
end
