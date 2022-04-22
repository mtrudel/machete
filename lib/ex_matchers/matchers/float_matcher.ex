defmodule ExMatchers.FloatMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.FloatMatcher{}, b), do: is_float(b)
  end
end
