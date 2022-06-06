defmodule ExMatchers.StringMatcher do
  defstruct []

  def string(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.StringMatcher{}, b) do
      unless is_binary(b) do
        [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a string"}]
      end
    end
  end
end
