defmodule ExMatchers.IntegerMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.IntegerMatcher{}, b), do: is_integer(b)
  end
end
