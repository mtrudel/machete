defmodule ExMatchers.BooleanMatcher do
  defstruct []

  def boolean(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.BooleanMatcher{}, b) do
      unless is_boolean(b) do
        [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a boolean"}]
      end
    end
  end
end
