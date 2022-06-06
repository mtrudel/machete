defmodule ExMatchers.DateMatcher do
  defstruct []

  def date(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.DateMatcher{}, %Date{}), do: nil

    def mismatches(%ExMatchers.DateMatcher{}, b),
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a Date"}]
  end
end
