defmodule IsAMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.IsAMatcher

  test "produces a useful mismatch for type mismatches" do
    assert %URI{}
           ~>> is_a(DateTime)
           ~> mismatch("#{inspect(%URI{})} is not a DateTime")
  end
end
