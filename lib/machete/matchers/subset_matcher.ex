defmodule Machete.SubsetMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct map: nil

  def subset(map), do: struct!(__MODULE__, map: map)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when not is_map(b), do: mismatch("#{inspect(b)} is not a map")

    def mismatches(%@for{} = a, b),
      do: Machete.Matchable.mismatches(Map.take(a.map, Map.keys(b)), b)
  end
end
