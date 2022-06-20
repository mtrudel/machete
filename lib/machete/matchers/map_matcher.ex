defmodule Machete.MapMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct []

  def map(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when is_map(b), do: nil
    def mismatches(%@for{}, b), do: mismatch("#{inspect(b)} is not a map")
  end
end
