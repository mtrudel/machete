defmodule ExMatchers.DateMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.DateMatcher{}, b), do: match?(%Date{}, b)
  end
end
