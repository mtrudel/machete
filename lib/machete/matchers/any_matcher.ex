defmodule Machete.AnyMatcher do
  @moduledoc """
  Defines a matcher that matches against a set of matchers, requiring at least one of them to match
  """

  import Machete.Mismatch
  import Machete.Operators

  defstruct matchers: []

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Matches against a set of matchers, requiring at least one of them to match

  Takes a list of matchers as its sole (mandatory) argument

  Examples:

      iex> assert "abc" ~> any([string(), integer()])
      true

      iex> refute :abc ~> any([string(), integer()])
      false
  """
  @spec any([Machete.Matchable.t()]) :: t()
  def any(matchers), do: struct!(__MODULE__, matchers: matchers)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      unless Enum.any?(a.matchers, &(b ~> &1)),
        do: mismatch("#{inspect(b)} does not match any of the specified matchers")
    end
  end
end
