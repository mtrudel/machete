defmodule ExMatchers.FloatMatcher do
  defstruct positive: nil, negative: nil, nonzero: nil, min: nil, max: nil

  def float(opts \\ []) do
    %__MODULE__{
      positive: Keyword.get(opts, :positive),
      negative: Keyword.get(opts, :negative),
      nonzero: Keyword.get(opts, :nonzero),
      min: Keyword.get(opts, :min),
      max: Keyword.get(opts, :max)
    }
  end

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.FloatMatcher{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_positive(b, a.positive),
           nil <- matches_negative(b, a.negative),
           nil <- matches_nonzero(b, a.nonzero),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max) do
      end
    end

    defp matches_type(b) when not is_float(b),
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a float"}]

    defp matches_type(_), do: nil

    defp matches_positive(b, true) when b < 0.0,
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not positive"}]

    defp matches_positive(b, false) when b >= 0.0,
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is positive"}]

    defp matches_positive(_, _), do: nil

    defp matches_negative(b, true) when b > 0.0,
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not negative"}]

    defp matches_negative(b, false) when b <= 0.0,
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is negative"}]

    defp matches_negative(_, _), do: nil

    defp matches_nonzero(b, true) when b == 0.0,
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is zero"}]

    defp matches_nonzero(b, false) when b != 0.0,
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not zero"}]

    defp matches_nonzero(_, _), do: nil

    defp matches_min(b, min) when is_float(min) and b < min,
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is less than #{min}"}]

    defp matches_min(_, _), do: nil

    defp matches_max(b, max) when is_float(max) and b > max,
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is greater than #{max}"}]

    defp matches_max(_, _), do: nil
  end
end
