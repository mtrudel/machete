defmodule Machete.FallbackMatcher do
  @moduledoc false

  # This module defines Machete.Matchable protocol conformance for 'Any', as a fallback mechanism
  # for literal comparison. Other than fallback struct comparison (which is done based on type
  # equivalency and map-wise comparison), equality is based on `===` semantics

  import Machete.Mismatch
  import Machete.Operators

  defimpl Machete.Matchable, for: Any do
    # Because 'structs' as a whole are not generally implementable, we need to consider struct
    # comparison as part of our Any implementation (structs which implement their own Matchable
    # conformance will not get here since they will not fallback to any). Assuming that struct
    # types match, structs are compared based on their map equivalents
    def mismatches(%t{} = a, %t{} = b), do: Map.from_struct(b) ~>> Map.from_struct(a)
    def mismatches(%_{}, %_{}), do: mismatch("Struct types do not match")
    def mismatches(%_{}, b), do: mismatch("#{inspect(b)} is not a struct")
    def mismatches(a, a), do: nil
    def mismatches(a, b), do: mismatch("#{inspect(b)} is not equal to #{inspect(a)}")
  end
end
