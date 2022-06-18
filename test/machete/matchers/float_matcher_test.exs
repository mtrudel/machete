defmodule FloatMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  test "matches floats" do
    assert 1.0 ~> float()
  end

  test "matches positive test when true" do
    assert 1.0 ~> float(positive: true)
    assert 0.0 ~> float(positive: true)
  end

  test "matches positive test when false" do
    assert -1.0 ~> float(positive: false)
    refute 0.0 ~> float(positive: false)
  end

  test "matches negative test when true" do
    assert -1.0 ~> float(negative: true)
    assert 0.0 ~> float(negative: true)
  end

  test "matches negative test when false" do
    assert 1.0 ~> float(negative: false)
    refute 0.0 ~> float(negative: false)
  end

  test "matches nonzero test when true" do
    assert 1.0 ~> float(nonzero: true)
  end

  test "matches nonzero test when false" do
    assert 0.0 ~> float(nonzero: false)
  end

  test "matches min test" do
    assert 2.0 ~> float(min: 2.0)
  end

  test "matches max test" do
    assert 2.0 ~> float(max: 2.0)
  end

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
