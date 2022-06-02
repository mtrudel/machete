defmodule ExMatchers.BooleanMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.BooleanMatcher{}, b) when is_boolean(b), do: []

    def mismatches(%ExMatchers.BooleanMatcher{}, _),
      do: [%ExMatchers.Mismatch{message: "Not a boolean"}]
  end
end
