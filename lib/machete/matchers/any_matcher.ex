defmodule Machete.AnyMatcher do
  @moduledoc false

  defstruct []

  def any(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, _), do: nil
  end
end
