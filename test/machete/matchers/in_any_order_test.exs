defmodule InAnyOrderMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.InAnyOrderMatcher

  test "produces a useful mismatch for no matches" do
    assert [1, 2]
           ~>> in_any_order([1, 3])
           ~> mismatch("[1, 2] does not match any ordering of the specified matchers")
  end
end
