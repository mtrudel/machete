defmodule ExMatchers.StringMatcher do
  defstruct []

  def string(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.StringMatcher{}, b) when is_binary(b), do: []

    def mismatches(%ExMatchers.StringMatcher{}, b),
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a string"}]
  end
end
