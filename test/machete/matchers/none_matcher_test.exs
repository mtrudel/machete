defmodule NoneMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.NoneMatcher

  test "produces a useful mismatch for no matches" do
    assert 123
           ~>> none([string(), integer()])
           ~> mismatch("123 matches at least one of the specified matchers")
  end
end
