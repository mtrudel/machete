defmodule Machete.AllMatcher do
  @moduledoc """
  Defines a matcher that matches against a set of matchers, requiring all of them to match
  """

  import Machete.Operators

  defstruct matchers: []

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Matches against a set of matchers, requiring all of them to match

  Takes a list of matchers as its sole (mandatory) argument

  Examples:

      iex> assert "abc" ~> all([term(), string()])
      true

      iex> refute :abc ~> all([term(), string()])
      false
  """
  @spec all([Machete.Matchable.t()]) :: t()
  def all(matchers), do: struct!(__MODULE__, matchers: matchers)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b), do: Enum.flat_map(a.matchers, &(b ~>> &1))
  end
end
