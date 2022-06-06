defmodule ExMatchers.IntegerMatcher do
  defstruct []

  def integer(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.IntegerMatcher{}, b) when is_integer(b), do: []

    def mismatches(%ExMatchers.IntegerMatcher{}, b),
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not an integer"}]
  end
end
