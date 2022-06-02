defmodule ExMatchers.DateMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.DateMatcher{}, %Date{}), do: []
    def mismatches(%ExMatchers.DateMatcher{}, _), do: [%ExMatchers.Mismatch{message: "Not a Date"}]
  end
end
