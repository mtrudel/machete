defmodule FalsyMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.FalsyMatcher

  test "produces a useful mismatch for truthy" do
    assert "abc" ~>> falsy() ~> mismatch("\"abc\" is not falsy")
  end
end
