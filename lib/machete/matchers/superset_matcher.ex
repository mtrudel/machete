defmodule Machete.SupersetMatcher do
  @moduledoc """
  Defines a matcher that matches maps which are a superset of a specified map
  """

  import Machete.Mismatch
  import Machete.Operators

  defstruct map: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Matches maps which are a superset of a specified map

  Takes a map as its sole (mandatory) argument

  Examples:
      iex> assert %{a: 1} ~> superset(%{a: 1})
      true

      iex> assert %{a: 1, b: 1} ~> superset(%{a: 1})
      true
  """
  @spec superset(map()) :: t()
  def superset(map), do: struct!(__MODULE__, map: map)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when not is_map(b), do: mismatch("#{safe_inspect(b)} is not a map")
    def mismatches(%@for{} = a, b), do: Map.take(b, Map.keys(a.map)) ~>> a.map
  end
end
