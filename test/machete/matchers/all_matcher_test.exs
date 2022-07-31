defmodule AllMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.AllMatcher

  test "produces a useful mismatch for no matches" do
    assert 123
           ~>> all([string(), atom()])
           ~> (mismatch("123 is not a string") ++ mismatch("123 is not an atom"))
  end
end
