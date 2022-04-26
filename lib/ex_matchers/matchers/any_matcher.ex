defmodule ExMatchers.AnyMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.AnyMatcher{}, _), do: true
  end
end
