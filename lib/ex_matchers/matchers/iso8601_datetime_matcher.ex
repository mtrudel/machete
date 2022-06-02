defmodule ExMatchers.ISO8601DateTimeMatcher do
  defstruct datetime_opts: nil

  def new(opts \\ []) do
    %__MODULE__{
      datetime_opts: opts
    }
  end

  defimpl ExMatchers.Matchable do
    def mismatches(%ExMatchers.ISO8601DateTimeMatcher{} = a, b) do
      DateTime.from_iso8601(b)
      |> case do
        {:ok, datetime_b, 0} ->
          a.datetime_opts
          |> ExMatchers.DateTimeMatcher.new()
          |> ExMatchers.Matchable.mismatches(datetime_b)

        _ ->
          [%ExMatchers.Mismatch{message: "Not a parseable ISO8601 datetime"}]
      end
    end
  end
end
