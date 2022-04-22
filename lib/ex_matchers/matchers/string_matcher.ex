defmodule ExMatchers.StringMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.StringMatcher{}, b), do: is_binary(b)
  end
end
