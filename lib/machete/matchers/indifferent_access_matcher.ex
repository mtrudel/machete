defmodule Machete.IndifferentAccessMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct map: nil

  def indifferent_access(map), do: struct!(__MODULE__, map: map)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when not is_map(b), do: mismatch("#{inspect(b)} is not a map")

    def mismatches(%@for{} = a, b) do
      mapped_b =
        b
        |> Enum.map(fn {k, v} ->
          cond do
            is_atom(k) and Map.has_key?(a.map, to_string(k)) -> {to_string(k), v}
            is_binary(k) and Map.has_key?(a.map, String.to_atom(k)) -> {String.to_atom(k), v}
            true -> {k, v}
          end
        end)
        |> Enum.into(%{})

      Machete.Matchable.mismatches(a.map, mapped_b)
    end
  end
end
