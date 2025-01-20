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
      mismatch_sets =
        a.matchers
        |> permutations()
        |> Enum.reduce_while([], fn a, acc ->
          mismatches = list_mismatches(a, b)

          if Enum.all?(mismatches, &Enum.empty?/1) do
            {:halt, []}
          else
            {:cont, [mismatches | acc]}
          end
        end)

      if mismatch_sets != [] do
        closest_mismatch_set =
          Enum.min_by(mismatch_sets, fn mismatch_set ->
            mismatch_set
            |> Enum.map(&length/1)
            |> Enum.sum()
          end)

        indent = "    "
        sub_indent = indent <> "  "

        sub_mismatches =
          closest_mismatch_set
          |> Enum.with_index(1)
          |> Enum.map_join("\n", fn
            {[], _idx} ->
              ""

            {mismatches, idx} ->
              "#{indent}.#{idx - 1}\n#{format_mismatches(mismatches, sub_indent)}"
          end)

        mismatch(
          "#{safe_inspect(b)} does not match any ordering of the specified matchers:\n" <>
            sub_mismatches
        )
      end
    end

    def mismatches(a, b) when is_list(b),
      do: mismatch("#{safe_inspect(b)} is not the same length as #{safe_inspect(a.matchers)}")

    def mismatches(_, b), do: mismatch("#{safe_inspect(b)} is not a list")

    defp permutations([]), do: [[]]

    defp permutations(list),
      do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

    defp list_mismatches(b, a) do
      Enum.zip(a, b)
      |> Enum.map(fn {a, b} -> a ~>> b end)
    end
  end
end
