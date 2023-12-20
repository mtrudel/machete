defmodule JSONMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.JSONMatcher

  test "produces a useful mismatch for non strings" do
    assert 1 ~>> json(term()) ~> mismatch("1 is not a string")
  end

  test "produces a useful mismatch for non-parseable strings" do
    assert "%" ~>> json(term()) ~> mismatch("\"%\" is not parseable JSON")
  end

  test "produces a useful mismatch for content mismatches" do
    assert "[1]"
           ~>> json([])
           ~> mismatch("List is 1 elements in length, expected 0")
  end
end
