defmodule Machete.ListOfMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct matcher: nil, min: nil, max: nil, length: nil

  def list_of(matcher, opts \\ []), do: struct!(__MODULE__, [matcher: matcher] ++ opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, b) when not is_list(b), do: mismatch("#{inspect(b)} is not a list")

    def mismatches(%@for{} = a, b) do
      with nil <- matches_length(b, a.length),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max),
           nil <- matches_matcher(b, a.matcher) do
      end
    end

    defp matches_length(_, nil), do: nil

    defp matches_length(b, length) do
      unless length(b) == length do
        mismatch("#{inspect(b)} is not exactly #{length} elements in length")
      end
    end

    defp matches_min(_, nil), do: nil

    defp matches_min(b, length) do
      unless length(b) >= length do
        mismatch("#{inspect(b)} is less than #{length} elements in length")
      end
    end

    defp matches_max(_, nil), do: nil

    defp matches_max(b, length) do
      unless length(b) <= length do
        mismatch("#{inspect(b)} is more than #{length} elements in length")
      end
    end

    defp matches_matcher(b, matcher) do
      matchers = [matcher] |> Stream.cycle() |> Enum.take(length(b))
      Machete.Matchable.mismatches(matchers, b)
    end
  end
end
