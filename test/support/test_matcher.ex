defmodule TestMatcher do
  @moduledoc false

  import Machete.Mismatch

  defstruct behaviour: nil

  def test_matcher(opts \\ []), do: struct!(__MODULE__, opts)

  defimpl Machete.Matchable do
    def mismatches(%TestMatcher{behaviour: :always_mismatch}, _), do: mismatch("Always mismatch")
    def mismatches(%TestMatcher{behaviour: :match_returning_list}, _), do: []
    def mismatches(%TestMatcher{behaviour: :match_returning_nil}, _), do: nil
  end
end
