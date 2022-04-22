defmodule ExMatchers.ISO8601DateTimeMatcher do
  defstruct datetime_opts: nil

  def new(opts \\ []) do
    %__MODULE__{
      datetime_opts: opts
    }
  end

  defimpl ExMatchers.Matchable do
    def matches?(%ExMatchers.ISO8601DateTimeMatcher{} = a, b) do
      DateTime.from_iso8601(b)
      |> case do
        {:ok, datetime_b, 0} ->
          a.datetime_opts
          |> ExMatchers.DateTimeMatcher.new()
          |> ExMatchers.Matchable.matches?(datetime_b)

        _ ->
          false
      end
    end
  end
end
