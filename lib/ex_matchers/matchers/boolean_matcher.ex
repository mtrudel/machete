defmodule ExMatchers.BooleanMatcher do
  defstruct []

  def boolean(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.BooleanMatcher{}, b) when is_boolean(b), do: []

    def mismatches(%ExMatchers.BooleanMatcher{}, b),
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a boolean"}]
  end
end
