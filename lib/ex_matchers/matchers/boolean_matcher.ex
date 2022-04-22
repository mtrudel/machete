defmodule ExMatchers.BooleanMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.BooleanMatcher{}, b), do: is_boolean(b)
  end
end
