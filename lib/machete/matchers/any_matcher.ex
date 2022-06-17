defmodule Machete.AnyMatcher do
  @moduledoc false

  defstruct []

  def any, do: %__MODULE__{}

  defimpl Machete.Matchable do
    def mismatches(%Machete.AnyMatcher{}, _), do: nil
  end
end
