defmodule Machete.RegexMatcher do
  @moduledoc false

  # This module defines Machete.Matchable protocol conformance for regexes,
  # using `match?/2` for matching semantics

  import Machete.Mismatch

  defimpl Machete.Matchable, for: Regex do
    def mismatches(%Regex{} = a, b) when is_binary(b) do
      unless Regex.match?(a, b), do: mismatch("#{inspect(b)} does not match #{inspect(a)}")
    end

    def mismatches(%Regex{}, b), do: mismatch("#{inspect(b)} is not a string")
  end
end
