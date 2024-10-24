defmodule Machete.IndifferentAccessMatcher do
  @moduledoc """
  Defines a matcher that matches indifferently (that is, it considers similar atom and string keys
  to be equivalent)
  """

  import Machete.Mismatch
  import Machete.Operators

  defstruct map: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Defines a matcher that matches indifferently (that is, it considers similar atom and string keys
  to be equivalent)

  Takes a map as its sole (mandatory) argument

  Examples:

      iex> assert %{a: 1} ~> indifferent_access(%{a: 1})
      true

      iex> assert %{"a" => 1} ~> indifferent_access(%{"a" => 1})
      true

      iex> assert %{a: 1} ~> indifferent_access(%{"a" => 1})
      true

      iex> assert %{"a" => 1} ~> indifferent_access(%{a: 1})
      true

      iex> assert %{1 => 1} ~> indifferent_access(%{1 => 1})
      true
  """
  @spec indifferent_access(map()) :: t()
  def indifferent_access(map), do: struct!(__MODULE__, map: map)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when not is_map(b), do: mismatch("#{inspect(b)} is not a map")

    def mismatches(%@for{} = a, b) do
      mapped_b =
        b
        |> Enum.sort()
        |> Enum.map(fn {k, v} ->
          cond do
            is_atom(k) and Map.has_key?(a.map, to_string(k)) -> {to_string(k), v}
            is_binary(k) and Map.has_key?(a.map, String.to_atom(k)) -> {String.to_atom(k), v}
            true -> {k, v}
          end
        end)
        |> Enum.into(%{})

      mapped_b ~>> a.map
    end
  end
end
