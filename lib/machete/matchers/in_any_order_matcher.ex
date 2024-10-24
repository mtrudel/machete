defmodule Machete.InAnyOrderMatcher do
  @moduledoc """
  Defines a matcher that matches lists in any order
  """

  import Machete.Mismatch
  import Machete.Operators

  defstruct matchers: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Matches lists in any order. Matchers are applied in all possible orders
  until one matches; *this can be exponentially expensive* for long lists.

  Examples:
      iex> assert [1] ~> in_any_order([1])
      true

      iex> assert [2, 1] ~> in_any_order([1, 2])
      true

      iex> assert [1, "a", :a] ~> in_any_order([string(), atom(), integer()])
      true

      iex> refute [1, 2] ~> in_any_order([1, 3])
      false
  """
  @spec in_any_order([Machete.Matchable.t()]) :: t()
  def in_any_order(matchers), do: struct!(__MODULE__, matchers: matchers)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) when is_list(b) and length(a.matchers) == length(b) do
      matches =
        a.matchers
        |> permutations()
        |> Enum.any?(&simple_list_match(&1, b))

      unless matches,
        do: mismatch("#{safe_inspect(b)} does not match any ordering of the specified matchers")
    end

    def mismatches(a, b) when is_list(b),
      do: mismatch("#{safe_inspect(b)} is not the same length as #{safe_inspect(a.matchers)}")

    def mismatches(_, b), do: mismatch("#{safe_inspect(b)} is not a list")

    defp permutations([]), do: [[]]

    defp permutations(list),
      do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

    defp simple_list_match(b, a), do: Enum.zip(a, b) |> Enum.all?(fn {a, b} -> a ~> b end)
  end
end
