defmodule ExMatchers.FloatMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.FloatMatcher{}, b) when is_float(b), do: []

    def mismatches(%ExMatchers.FloatMatcher{}, _),
      do: [%ExMatchers.Mismatch{message: "Not a float"}]
  end
end
