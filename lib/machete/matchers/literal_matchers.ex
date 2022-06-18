defmodule Machete.LiteralMatchers do
  @moduledoc """
  This module defines Machete.Matchable protocol conformance for a number of 
  literal types. We use whichever equality semantic is indicated for the type (`match?/2` for
  Regex, `compare/2` for date-like types, `===` for everything else).

  Note that literal collection matching is not handled here; each collection type has their own
  literal matcher module defined separately.
  """

  defimpl Machete.Matchable, for: Regex do
    def mismatches(%Regex{} = a, b) when is_binary(b) do
      unless Regex.match?(a, b) do
        [%Machete.Mismatch{message: "#{inspect(b)} does not match #{inspect(a)}"}]
      end
    end

    def mismatches(%Regex{}, b),
      do: [%Machete.Mismatch{message: "#{inspect(b)} is not a string"}]
  end

  defimpl Machete.Matchable, for: [DateTime, NaiveDateTime, Date, Time] do
    def mismatches(%@for{} = a, %@for{} = b) do
      if @for.compare(a, b) != :eq do
        [%Machete.Mismatch{message: "#{inspect(b)} is not equal to #{inspect(a)}"}]
      end
    end

    def mismatches(%@for{}, b),
      do: [%Machete.Mismatch{message: "#{b} is not a #{inspect(@for)}"}]
  end

  defimpl Machete.Matchable, for: Any do
    # We need to do struct matching in Any. Assuming that struct types match,
    # structs are compared based on their map equivalents
    def mismatches(%t{} = a, %t{} = b) do
      Machete.Matchable.mismatches(Map.from_struct(a), Map.from_struct(b))
    end

    def mismatches(a, _) when is_struct(a) do
      [%Machete.Mismatch{message: "Struct types do not match"}]
    end

    def mismatches(a, a), do: nil

    def mismatches(a, b),
      do: [%Machete.Mismatch{message: "#{inspect(b)} is not equal to #{inspect(a)}"}]
  end
end
