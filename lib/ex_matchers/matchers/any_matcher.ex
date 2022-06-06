defmodule ExMatchers.AnyMatcher do
  defstruct []

  def any(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.AnyMatcher{}, _), do: nil
  end
end
