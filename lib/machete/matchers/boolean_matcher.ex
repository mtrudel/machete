defmodule Machete.BooleanMatcher do
  defstruct []

  def boolean(), do: %__MODULE__{}

  defimpl Machete.Matchable do
    def mismatches(%Machete.BooleanMatcher{}, b) do
      unless is_boolean(b) do
        [%Machete.Mismatch{message: "#{inspect(b)} is not a boolean"}]
      end
    end
  end
end
