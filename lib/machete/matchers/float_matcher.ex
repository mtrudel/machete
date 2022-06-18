defmodule Machete.FloatMatcher do
  @moduledoc false

  defstruct positive: nil, negative: nil, nonzero: nil, min: nil, max: nil

  def float(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_positive(b, a.positive),
           nil <- matches_negative(b, a.negative),
           nil <- matches_nonzero(b, a.nonzero),
           nil <- matches_min(b, a.min),
           nil <- matches_max(b, a.max) do
      end
    end

    defp matches_type(b) when not is_float(b),
      do: [%Machete.Mismatch{message: "#{inspect(b)} is not a float"}]

    defp matches_type(_), do: nil

    defp matches_positive(b, true) when b < 0.0,
      do: [%Machete.Mismatch{message: "#{inspect(b)} is not positive"}]

    defp matches_positive(b, false) when b >= 0.0,
      do: [%Machete.Mismatch{message: "#{inspect(b)} is positive"}]

    defp matches_positive(_, _), do: nil

    defp matches_negative(b, true) when b > 0.0,
      do: [%Machete.Mismatch{message: "#{inspect(b)} is not negative"}]

    defp matches_negative(b, false) when b <= 0.0,
      do: [%Machete.Mismatch{message: "#{inspect(b)} is negative"}]

    defp matches_negative(_, _), do: nil

    defp matches_nonzero(b, true) when b == 0.0,
      do: [%Machete.Mismatch{message: "#{inspect(b)} is zero"}]

    defp matches_nonzero(b, false) when b != 0.0,
      do: [%Machete.Mismatch{message: "#{inspect(b)} is not zero"}]

    defp matches_nonzero(_, _), do: nil

    defp matches_min(b, min) when is_float(min) and b < min,
      do: [%Machete.Mismatch{message: "#{inspect(b)} is less than #{min}"}]

    defp matches_min(_, _), do: nil

    defp matches_max(b, max) when is_float(max) and b > max,
      do: [%Machete.Mismatch{message: "#{inspect(b)} is greater than #{max}"}]

    defp matches_max(_, _), do: nil
  end
end
