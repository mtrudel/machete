defmodule Machete.LiteralMatchers do
  @moduledoc """
  This module defines Machete.Matchable protocol conformance for a number of 
  literal types. We use whichever equality semantic is indicated for the type (`match?/2` for
  Regex, `compare/2` for date-like types, `===` for everything else).

  Note that literal collection matching is not handled here; each collection type has their own
  literal matcher module defined separately.
  """

  import Machete.Mismatch

  defimpl Machete.Matchable, for: Regex do
    def mismatches(%Regex{} = a, b) when is_binary(b) do
      unless Regex.match?(a, b), do: mismatch("#{inspect(b)} does not match #{inspect(a)}")
    end

    def mismatches(%Regex{}, b), do: mismatch("#{inspect(b)} is not a string")
  end

  defimpl Machete.Matchable, for: [DateTime, NaiveDateTime, Date, Time] do
    def mismatches(%@for{} = a, %@for{} = b) do
      if @for.compare(a, b) != :eq, do: mismatch("#{inspect(b)} is not equal to #{inspect(a)}")
    end

    def mismatches(%@for{}, b), do: mismatch("#{b} is not a #{inspect(@for)}")
  end

  defimpl Machete.Matchable, for: Any do
    # We need to do struct matching in Any. Assuming that struct types match,
    # structs are compared based on their map equivalents
    def mismatches(%t{} = a, %t{} = b) do
      Machete.Matchable.mismatches(Map.from_struct(a), Map.from_struct(b))
    end

    def mismatches(%_{}, %_{}), do: mismatch("Struct types do not match")
    def mismatches(%_{}, b), do: mismatch("#{inspect(b)} is not a struct")
    def mismatches(a, a), do: nil
    def mismatches(a, b), do: mismatch("#{inspect(b)} is not equal to #{inspect(a)}")
  end
end
