defmodule Machete.ISO8601DateTimeMatcher do
  @moduledoc false

  defstruct datetime_opts: nil

  def iso8601_datetime(opts \\ []), do: struct!(__MODULE__, datetime_opts: opts)

  defimpl Machete.Matchable do
    def mismatches(%@for{} = a, b) when is_binary(b) do
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

    def mismatches(%@for{}, b),
      do: [%Machete.Mismatch{message: "#{inspect(b)} is not a string"}]
  end
end
