defmodule ExMatchers.DateTimeMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.DateTimeMatcher{}, b), do: match?(%DateTime{}, b)
  end
end
