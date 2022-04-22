defmodule ExMatchers.DateTimeMatcher do
  defstruct precision: nil

  def new(opts \\ []) do
    %__MODULE__{
      precision: Keyword.get(opts, :precision)
    }
  end

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.DateTimeMatcher{} = a, b) do
      match?(%DateTime{}, b) && matches_precision?(b, a.precision)
    end

    defp matches_precision?(_, nil), do: true
    defp matches_precision?(%{microsecond: {_, precision}}, precision), do: true
    defp matches_precision?(_, _), do: false
  end
end
