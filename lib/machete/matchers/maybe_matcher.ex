defmodule Machete.MaybeMatcher do
  @moduledoc false

  defstruct matcher: nil

  def maybe(matcher), do: struct!(__MODULE__, matcher: matcher)

  defimpl Machete.Matchable do
    def mismatches(%@for{}, nil), do: nil
    def mismatches(%@for{} = a, b), do: Machete.Matchable.mismatches(a.matcher, b)
  end
end
