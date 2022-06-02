defmodule ExMatchers.IntegerMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.IntegerMatcher{}, b) when is_integer(b), do: []

    def mismatches(%ExMatchers.IntegerMatcher{}, _),
      do: [%ExMatchers.Mismatch{message: "Not a integer"}]
  end
end
