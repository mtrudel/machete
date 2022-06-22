defmodule Machete.MaybeMatcher do
  @moduledoc """
  Defines a matcher that matches against another matcher & also matches nil
  """

  import Machete.Operators

  defstruct matcher: nil

  @typedoc """
  Describes an instance of this matcher
  """
  @opaque t :: %__MODULE__{}

  @doc """
  Matches against another matcher & also matches nil

  Takes another matcher as its sole (mandatory) argument

  Examples:

      iex> assert nil ~> maybe(string())
      true

      iex> assert "abc" ~> maybe(string())
      true
  """
  @spec maybe(Machete.Matchable.t()) :: t()
  def maybe(matcher), do: struct!(__MODULE__, matcher: matcher)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, nil), do: nil
    def mismatches(%@for{} = a, b), do: b ~>> a.matcher
  end
end
