defmodule ExMatchers.StringMatcher do
  defstruct empty: nil, length: nil, min: nil, max: nil

  def string(opts \\ []) do
    %__MODULE__{
      empty: Keyword.get(opts, :empty),
      length: Keyword.get(opts, :length),
      min: Keyword.get(opts, :min),
      max: Keyword.get(opts, :max)
    }
  end

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.StringMatcher{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_empty(b, a.empty),
           nil <- matches_length(b, a.length),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max) do
      end
    end

    defp matches_type(b) when is_binary(b), do: nil
    defp matches_type(b), do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a string"}]

    defp matches_empty("" = b, false),
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is empty"}]

    defp matches_empty(b, true) when b != "",
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not empty"}]

    defp matches_empty(_, _), do: nil

    defp matches_length(_, nil), do: nil

    defp matches_length(b, length) do
      unless String.length(b) == length do
        [%ExMatchers.Mismatch{message: "#{inspect(b)} is not exactly #{length} characters"}]
      end
    end

    defp matches_min(_, nil), do: nil

    defp matches_min(b, length) do
      unless String.length(b) >= length do
        [%ExMatchers.Mismatch{message: "#{inspect(b)} is less than #{length} characters"}]
      end
    end

    defp matches_max(_, nil), do: nil

    defp matches_max(b, length) do
      unless String.length(b) <= length do
        [%ExMatchers.Mismatch{message: "#{inspect(b)} is more than #{length} characters"}]
      end
    end
  end
end
