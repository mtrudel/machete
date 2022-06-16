defmodule Machete.ISO8601DateTimeMatcher do
  defstruct datetime_opts: nil

  def iso8601_datetime(opts \\ []) do
    %__MODULE__{
      datetime_opts: opts
    }
  end

  defimpl Machete.Matchable do
    def mismatches(%Machete.ISO8601DateTimeMatcher{} = a, b) when is_binary(b) do
      DateTime.from_iso8601(b)
      |> case do
        {:ok, datetime_b, 0} ->
          a.datetime_opts
          |> Machete.DateTimeMatcher.datetime()
          |> Machete.Matchable.mismatches(datetime_b)

        _ ->
          [%Machete.Mismatch{message: "#{inspect(b)} is not a parseable ISO8601 datetime"}]
      end
    end

    def mismatches(%Machete.ISO8601DateTimeMatcher{}, b),
      do: [%Machete.Mismatch{message: "#{inspect(b)} is not a string"}]
  end
end
