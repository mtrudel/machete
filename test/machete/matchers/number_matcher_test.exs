defmodule NumberMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.NumberMatcher

  test "produces a useful mismatch for non numbers" do
    assert "1" ~>> number() ~> mismatch("\"1\" is not a number")
  end

  test "produces a useful mismatch for positive mismatch (true)" do
    assert -1.0 ~>> number(positive: true) ~> mismatch("-1.0 is not positive")
    assert -1 ~>> number(positive: true) ~> mismatch("-1 is not positive")
  end

  test "produces a useful mismatch for positive mismatch (false)" do
    assert 1.0 ~>> number(positive: false) ~> mismatch("1.0 is positive")
    assert 1 ~>> number(positive: false) ~> mismatch("1 is positive")
  end

  test "produces a useful mismatch for strictly positive mismatch (true)" do
    assert -1.0 ~>> number(strictly_positive: true) ~> mismatch("-1.0 is not strictly positive")
    assert -1 ~>> number(strictly_positive: true) ~> mismatch("-1 is not strictly positive")
  end

  test "produces a useful mismatch for strictly positive mismatch (false)" do
    assert 1.0 ~>> number(strictly_positive: false) ~> mismatch("1.0 is strictly positive")
    assert 1 ~>> number(strictly_positive: false) ~> mismatch("1 is strictly positive")
  end

  test "produces a useful mismatch for negative mismatch (true)" do
    assert 1.0 ~>> number(negative: true) ~> mismatch("1.0 is not negative")
    assert 1 ~>> number(negative: true) ~> mismatch("1 is not negative")
  end

  test "produces a useful mismatch for negative mismatch (false)" do
    assert -1.0 ~>> number(negative: false) ~> mismatch("-1.0 is negative")
    assert -1 ~>> number(negative: false) ~> mismatch("-1 is negative")
  end

  test "produces a useful mismatch for strictly negative mismatch (true)" do
    assert 1.0 ~>> number(strictly_negative: true) ~> mismatch("1.0 is not strictly negative")
    assert 1 ~>> number(strictly_negative: true) ~> mismatch("1 is not strictly negative")
  end

  test "produces a useful mismatch for strictly negative mismatch (false)" do
    assert -1.0 ~>> number(strictly_negative: false) ~> mismatch("-1.0 is strictly negative")
    assert -1 ~>> number(strictly_negative: false) ~> mismatch("-1 is strictly negative")
  end

  test "produces a useful mismatch for nonzero mismatch (true)" do
    assert 0.0 ~>> number(nonzero: true) ~> mismatch("0.0 is zero")
    assert 0 ~>> number(nonzero: true) ~> mismatch("0 is zero")
  end

  test "produces a useful mismatch for nonzero mismatch (false)" do
    assert 1.0 ~>> number(nonzero: false) ~> mismatch("1.0 is not zero")
    assert 1 ~>> number(nonzero: false) ~> mismatch("1 is not zero")
  end

  test "produces a useful mismatch for min mismatch" do
    assert 1.0 ~>> number(min: 2.0) ~> mismatch("1.0 is less than 2.0")
    assert 1 ~>> number(min: 2.0) ~> mismatch("1 is less than 2.0")
  end

  test "produces a useful mismatch for max mismatch" do
    assert 2.0 ~>> number(max: 1.0) ~> mismatch("2.0 is greater than 1.0")
    assert 2 ~>> number(max: 1.0) ~> mismatch("2 is greater than 1.0")
  end

  test "produces a useful mismatch for roughly mismatch" do
    assert 94.0 ~>> number(roughly: 100.0) ~> mismatch("94.0 is not roughly equal to 100.0")
    assert 94 ~>> number(roughly: 100.0) ~> mismatch("94 is not roughly equal to 100.0")
  end

  test "raises when provided with a roughly value of 0.0" do
    assert_raise(RuntimeError, "Must specify a value for `epsilon` when `roughly` is 0.0", fn ->
      assert 94.0 ~>> number(roughly: 0.0)
    end)
  end
end
