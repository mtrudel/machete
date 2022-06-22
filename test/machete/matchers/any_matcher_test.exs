defmodule AnyMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.AnyMatcher

  test "produces a useful mismatch for no matches" do
    assert 123 ~>> any([string()]) ~> mismatch("123 does not match any of the specified matchers")
  end
end
