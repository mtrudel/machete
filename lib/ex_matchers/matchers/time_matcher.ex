defmodule ExMatchers.TimeMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.TimeMatcher{}, b), do: match?(%Time{}, b)
  end
end
