defmodule Machete.FalsyMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct []

  def falsy(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, nil), do: nil
    def mismatches(%@for{}, false), do: nil
    def mismatches(%@for{}, b), do: mismatch("#{inspect(b)} is not falsy")
  end
end
