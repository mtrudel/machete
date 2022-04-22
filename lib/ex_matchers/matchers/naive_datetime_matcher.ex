defmodule ExMatchers.NaiveDateTimeMatcher do
  defstruct []

  def new(), do: %__MODULE__{}

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.NaiveDateTimeMatcher{}, b), do: match?(%NaiveDateTime{}, b)
  end
end
