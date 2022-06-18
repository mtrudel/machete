defmodule Machete.BooleanMatcher do
  @moduledoc false

  defstruct []

  def boolean(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) do
      unless is_boolean(b) do
        [%Machete.Mismatch{message: "#{inspect(b)} is not a boolean"}]
      end
    end
  end
end
