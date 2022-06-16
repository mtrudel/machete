defmodule IntegerMatcherTest do
  use ExUnit.Case, async: true
  use Machete

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
    assert 1.0 ~>> integer() ~> [%Machete.Mismatch{message: "1.0 is not an integer", path: []}]
  end

  test "produces a useful mismatch for positive mismatch (true)" do
    assert -1
           ~>> integer(positive: true)
           ~> [%Machete.Mismatch{message: "-1 is not positive", path: []}]
  end

  test "produces a useful mismatch for positive mismatch (false)" do
    assert 1
           ~>> integer(positive: false)
           ~> [%Machete.Mismatch{message: "1 is positive", path: []}]
  end

  test "produces a useful mismatch for negative mismatch (true)" do
    assert 1
           ~>> integer(negative: true)
           ~> [%Machete.Mismatch{message: "1 is not negative", path: []}]
  end

  test "produces a useful mismatch for negative mismatch (false)" do
    assert -1
           ~>> integer(negative: false)
           ~> [%Machete.Mismatch{message: "-1 is negative", path: []}]
  end

  test "produces a useful mismatch for nonzero mismatch (true)" do
    assert 0
           ~>> integer(nonzero: true)
           ~> [%Machete.Mismatch{message: "0 is zero", path: []}]
  end

  test "produces a useful mismatch for nonzero mismatch (false)" do
    assert 1
           ~>> integer(nonzero: false)
           ~> [%Machete.Mismatch{message: "1 is not zero", path: []}]
  end

  test "produces a useful mismatch for min mismatch" do
    assert 1
           ~>> integer(min: 2)
           ~> [%Machete.Mismatch{message: "1 is less than 2", path: []}]
  end

  test "produces a useful mismatch for max mismatch" do
    assert 2
           ~>> integer(max: 1)
           ~> [%Machete.Mismatch{message: "2 is greater than 1", path: []}]
  end
end
