defmodule Machete.DateMatcher do
  @moduledoc false

  defstruct roughly: nil, before: nil, after: nil

  def date(opts \\ []),
    do: %__MODULE__{
      roughly: Keyword.get(opts, :roughly),
      before: Keyword.get(opts, :before),
      after: Keyword.get(opts, :after)
    }

  defimpl Machete.Matchable do
    def mismatches(%Machete.DateMatcher{} = a, b) do
      with nil <- matches_type(b),
           nil <- matches_roughly(b, a.roughly),
           nil <- matches_before(b, a.before),
           nil <- matches_after(b, a.after) do
      end
    end

    defp matches_type(%Date{}), do: nil
    defp matches_type(b), do: [%Machete.Mismatch{message: "#{inspect(b)} is not a Date"}]

    defp matches_roughly(_, nil), do: nil
    defp matches_roughly(b, :today), do: matches_roughly(b, Date.utc_today())

    defp matches_roughly(b, roughly) do
      if Date.diff(b, roughly) not in -1..1 do
        [
          %Machete.Mismatch{
            message: "#{inspect(b)} is not within 1 day of #{inspect(roughly)}"
          }
        ]
      end
    end

    defp matches_before(_, nil), do: nil
    defp matches_before(b, :today), do: matches_before(b, Date.utc_today())

    defp matches_before(b, before) do
      if Date.compare(b, before) != :lt do
        [
          %Machete.Mismatch{
            message: "#{inspect(b)} is not before #{inspect(before)}"
          }
        ]
      end
    end

    defp matches_after(_, nil), do: nil
    defp matches_after(b, :today), do: matches_after(b, Date.utc_today())

    defp matches_after(b, after_var) do
      if Date.compare(b, after_var) != :gt do
        [
          %Machete.Mismatch{
            message: "#{inspect(b)} is not after #{inspect(after_var)}"
          }
        ]
      end
    end
  end
end
