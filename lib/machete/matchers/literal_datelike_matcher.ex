defmodule Machete.LiteralDateLikeMatcher do
  @moduledoc false

  # This module defines Machete.Matchable protocol conformance for literal DateTime, NaiveDateTime,
  # Date # and Time types. Note that these matchers match literal values and are distinct from the
  # parametrized matchers defined on these types elsewhere. Comparison is done using the relevant
  # module's `compare/2` function

  import Machete.Mismatch

  defimpl Machete.Matchable, for: [DateTime, NaiveDateTime, Date, Time] do
    def mismatches(%@for{} = a, %@for{} = b) do
      if @for.compare(a, b) != :eq,
        do: mismatch("#{safe_inspect(b)} is not equal to #{safe_inspect(a)}")
    end

    def mismatches(%@for{}, b), do: mismatch("#{b} is not a #{safe_inspect(@for)}")
  end
end
