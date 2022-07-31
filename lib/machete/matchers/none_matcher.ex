defmodule Machete.NoneMatcher do
  @moduledoc """
  Defines a matcher that matches against a set of matchers, requiring none of them to match
  """

  import Machete.Mismatch
  import Machete.Operators

  defstruct matchers: []

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Matches against a set of matchers, requiring none of them to match

  Takes a list of matchers as its sole (mandatory) argument

  Examples:

      iex> assert "abc" ~> none([integer(), float()])
      true

      iex> refute :abc ~> all([atom(), string()])
      false
  """
  @spec none([Machete.Matchable.t()]) :: t()
  def none(matchers), do: struct!(__MODULE__, matchers: matchers)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      if Enum.any?(a.matchers, &(b ~> &1)),
        do: mismatch("#{inspect(b)} matches at least one of the specified matchers")
    end
  end
end
