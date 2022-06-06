defmodule ExMatchers.IntegerMatcher do
  defstruct []

  def integer(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.IntegerMatcher{}, b) do
      unless is_integer(b) do
        [%ExMatchers.Mismatch{message: "#{inspect(b)} is not an integer"}]
      end
    end
  end
end
