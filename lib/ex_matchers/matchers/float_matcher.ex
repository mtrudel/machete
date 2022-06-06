defmodule ExMatchers.FloatMatcher do
  defstruct []

  def float(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.FloatMatcher{}, b) do
      unless is_float(b) do
        [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a float"}]
      end
    end
  end
end
