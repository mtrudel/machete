defmodule IntegerMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  test "matches integers" do
    assert 1 ~> integer()
  end

  test "matches positive test when true" do
    assert 1 ~> integer(positive: true)
    assert 0 ~> integer(positive: true)
  end

  test "matches positive test when false" do
    assert -1 ~> integer(positive: false)
    refute 0 ~> integer(positive: false)
  end

  test "matches negative test when true" do
    assert -1 ~> integer(negative: true)
    assert 0 ~> integer(negative: true)
  end

  test "matches negative test when false" do
    assert 1 ~> integer(negative: false)
    refute 0 ~> integer(negative: false)
  end

  test "matches nonzero test when true" do
    assert 1 ~> integer(nonzero: true)
  end

  test "matches nonzero test when false" do
    assert 0 ~> integer(nonzero: false)
  end

  test "matches min test" do
    assert 2 ~> integer(min: 2)
  end

  test "matches max test" do
    assert 2 ~> integer(max: 2)
  end

  test "produces a useful mismatch for non integers" do
    assert 1.0 ~>> integer() ~> mismatch("1.0 is not an integer")
  end

  test "produces a useful mismatch for positive mismatch (true)" do
    assert -1 ~>> integer(positive: true) ~> mismatch("-1 is not positive")
  end

  test "produces a useful mismatch for positive mismatch (false)" do
    assert 1 ~>> integer(positive: false) ~> mismatch("1 is positive")
  end

  test "produces a useful mismatch for negative mismatch (true)" do
    assert 1 ~>> integer(negative: true) ~> mismatch("1 is not negative")
  end

  test "produces a useful mismatch for negative mismatch (false)" do
    assert -1 ~>> integer(negative: false) ~> mismatch("-1 is negative")
  end

  test "produces a useful mismatch for nonzero mismatch (true)" do
    assert 0 ~>> integer(nonzero: true) ~> mismatch("0 is zero")
  end

  test "produces a useful mismatch for nonzero mismatch (false)" do
    assert 1 ~>> integer(nonzero: false) ~> mismatch("1 is not zero")
  end

  test "produces a useful mismatch for min mismatch" do
    assert 1 ~>> integer(min: 2) ~> mismatch("1 is less than 2")
  end

  test "produces a useful mismatch for max mismatch" do
    assert 2 ~>> integer(max: 1) ~> mismatch("2 is greater than 1")
  end
end
