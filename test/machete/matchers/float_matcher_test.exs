defmodule FloatMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.FloatMatcher

  test "produces a useful mismatch for non floats" do
    assert 1 ~>> float() ~> mismatch("1 is not a float")
  end

  test "produces a useful mismatch for positive mismatch (true)" do
    assert -1.0 ~>> float(positive: true) ~> mismatch("-1.0 is not positive")
  end

  test "produces a useful mismatch for positive mismatch (false)" do
    assert 1.0 ~>> float(positive: false) ~> mismatch("1.0 is positive")
  end

  test "produces a useful mismatch for negative mismatch (true)" do
    assert 1.0 ~>> float(negative: true) ~> mismatch("1.0 is not negative")
  end

  test "produces a useful mismatch for negative mismatch (false)" do
    assert -1.0 ~>> float(negative: false) ~> mismatch("-1.0 is negative")
  end

  test "produces a useful mismatch for nonzero mismatch (true)" do
    assert 0.0 ~>> float(nonzero: true) ~> mismatch("0.0 is zero")
  end

  test "produces a useful mismatch for nonzero mismatch (false)" do
    assert 1.0 ~>> float(nonzero: false) ~> mismatch("1.0 is not zero")
  end

  test "produces a useful mismatch for min mismatch" do
    assert 1.0 ~>> float(min: 2.0) ~> mismatch("1.0 is less than 2.0")
  end

  test "produces a useful mismatch for max mismatch" do
    assert 2.0 ~>> float(max: 1.0) ~> mismatch("2.0 is greater than 1.0")
  end
end
