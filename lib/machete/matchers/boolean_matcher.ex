defmodule Machete.BooleanMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct []

  def boolean(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) do
      unless is_boolean(b), do: mismatch("#{inspect(b)} is not a boolean")
    end
  end
end
