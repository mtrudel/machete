defmodule Machete.SupersetMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct map: nil

  def superset(map), do: struct!(__MODULE__, map: map)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when not is_map(b), do: mismatch("#{inspect(b)} is not a map")

    def mismatches(%@for{} = a, b),
      do: Machete.Matchable.mismatches(a.map, Map.take(b, Map.keys(a.map)))
  end
end
