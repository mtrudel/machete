defmodule Machete.TruthyMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct []

  def truthy(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, nil), do: mismatch("nil is not truthy")
    def mismatches(%@for{}, false), do: mismatch("false is not truthy")
    def mismatches(%@for{}, _), do: nil
  end
end
