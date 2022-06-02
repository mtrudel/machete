defmodule ExMatchers.StringMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.StringMatcher{}, b) when is_binary(b), do: []

    def mismatches(%ExMatchers.StringMatcher{}, _),
      do: [%ExMatchers.Mismatch{message: "Not a string"}]
  end
end
