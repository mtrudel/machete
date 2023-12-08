defmodule Machete.JSONMatcher do
  @moduledoc """
  Defines a matcher that matches JSON documents
  """

  import Machete.Mismatch
  import Machete.Operators

  defstruct matcher: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Matches against JSON documents whose deserialization matches a provided matcher

  Takes a matcher as its sole (mandatory) argument

  Examples:

      iex> assert "{}" ~> json(map())
      true

      iex> assert ~s({"a": 1}) ~> json(%{"a" => 1})
      true

      iex> assert "[]" ~> json(list())
      true

      iex> assert "[1,2,3]" ~> json([1,2,3])
      true

      iex> assert ~s("abc") ~> json(string())
      true

      iex> assert "123" ~> json(integer())
      true

      iex> assert "true" ~> json(boolean())
      true

      iex> assert "null" ~> json(nil)
      true
  """
  @spec json(term()) :: t()
  def json(matcher), do: struct!(__MODULE__, matcher: matcher)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) when is_binary(b) do
      Jason.decode(b)
      |> case do
        {:ok, document} -> document ~>> a.matcher
        _ -> mismatch("#{inspect(b)} is not parseable JSON")
      end
    end

    def mismatches(%@for{}, b), do: mismatch("#{inspect(b)} is not a string")
  end
end
