defmodule ExMatchers.LiteralMatchers do
  @moduledoc """
  This module defines ExMatchers.Matchable protocol conformance for a number of 
  literal types. The general contract here is one of strict (`===`) equality
  semantics, though for types with imperative equality (ie: `Regex`, `DateTime`, &c)
  the suggested equality operation is used instead.

  Note that literal collection matching is not handled here; each collection type has their own
  literal matcher module defined separately.
  """

  defimpl ExMatchers.Matchable, for: Regex do
    def matches?(%Regex{} = a, b) when is_binary(b), do: Regex.match?(a, b)
    def matches?(%Regex{}, _), do: false
  end

  for t <- [DateTime, NaiveDateTime, Date, Time] do
    defimpl ExMatchers.Matchable, for: t do
      def matches?(%unquote(t){} = a, %unquote(t){} = b), do: unquote(t).compare(a, b) === :eq
      def matches?(%unquote(t){}, _), do: false
    end
  end

  defimpl ExMatchers.Matchable, for: Any do
    def matches?(a, b), do: a === b
  end
end
