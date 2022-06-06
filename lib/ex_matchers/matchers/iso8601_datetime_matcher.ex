defmodule ExMatchers.ISO8601DateTimeMatcher do
  defstruct datetime_opts: nil

  def iso8601_datetime(opts \\ []) do
    %__MODULE__{
      datetime_opts: opts
    }
  end

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.ISO8601DateTimeMatcher{} = a, b) when is_binary(b) do
      DateTime.from_iso8601(b)
      |> case do
        {:ok, datetime_b, 0} ->
          a.datetime_opts
          |> ExMatchers.DateTimeMatcher.datetime()
          |> ExMatchers.Matchable.mismatches(datetime_b)

        _ ->
          [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a parseable ISO8601 datetime"}]
      end
    end

    def mismatches(%ExMatchers.ISO8601DateTimeMatcher{}, b),
      do: [%ExMatchers.Mismatch{message: "#{inspect(b)} is not a string"}]
  end
end
