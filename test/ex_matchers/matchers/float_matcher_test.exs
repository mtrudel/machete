defmodule FloatMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

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
    assert 1 ~>> float() ~> [%ExMatchers.Mismatch{message: "1 is not a float", path: []}]
  end

  test "produces a useful mismatch for positive mismatch (true)" do
    assert -1.0
           ~>> float(positive: true)
           ~> [%ExMatchers.Mismatch{message: "-1.0 is not positive", path: []}]
  end

  test "produces a useful mismatch for positive mismatch (false)" do
    assert 1.0
           ~>> float(positive: false)
           ~> [%ExMatchers.Mismatch{message: "1.0 is positive", path: []}]
  end

  test "produces a useful mismatch for negative mismatch (true)" do
    assert 1.0
           ~>> float(negative: true)
           ~> [%ExMatchers.Mismatch{message: "1.0 is not negative", path: []}]
  end

  test "produces a useful mismatch for negative mismatch (false)" do
    assert -1.0
           ~>> float(negative: false)
           ~> [%ExMatchers.Mismatch{message: "-1.0 is negative", path: []}]
  end

  test "produces a useful mismatch for nonzero mismatch (true)" do
    assert 0.0
           ~>> float(nonzero: true)
           ~> [%ExMatchers.Mismatch{message: "0.0 is zero", path: []}]
  end

  test "produces a useful mismatch for nonzero mismatch (false)" do
    assert 1.0
           ~>> float(nonzero: false)
           ~> [%ExMatchers.Mismatch{message: "1.0 is not zero", path: []}]
  end

  test "produces a useful mismatch for min mismatch" do
    assert 1.0
           ~>> float(min: 2.0)
           ~> [%ExMatchers.Mismatch{message: "1.0 is less than 2.0", path: []}]
  end

  test "produces a useful mismatch for max mismatch" do
    assert 2.0
           ~>> float(max: 1.0)
           ~> [%ExMatchers.Mismatch{message: "2.0 is greater than 1.0", path: []}]
  end
end
