defmodule StringMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  test "matches strings" do
    assert "" ~> string()
  end

  test "matches strings on exact length match" do
    assert "abc" ~> string(length: 3)
  end

  test "matches strings on min match" do
    assert "abc" ~> string(min: 3)
  end

  test "matches strings on max match" do
    assert "abc" ~> string(max: 3)
  end

  test "matches strings on empty true" do
    assert "" ~> string(empty: true)
  end

  test "matches strings on empty false" do
    assert "abc" ~> string(empty: false)
  end

  test "produces a useful mismatch for non strings" do
    assert 1 ~>> string() ~> [%Machete.Mismatch{message: "1 is not a string", path: []}]
  end

  test "produces a useful mismatch for exact length mismatches" do
    assert "a"
           ~>> string(length: 5)
           ~> [%Machete.Mismatch{message: "\"a\" is not exactly 5 characters", path: []}]
  end

  test "produces a useful mismatch for min length mismatches" do
    assert "a"
           ~>> string(min: 5)
           ~> [%Machete.Mismatch{message: "\"a\" is less than 5 characters", path: []}]
  end

  test "produces a useful mismatch for max length mismatches" do
    assert "abcdef"
           ~>> string(max: 5)
           ~> [%Machete.Mismatch{message: "\"abcdef\" is more than 5 characters", path: []}]
  end

  test "produces a useful mismatch for empty true" do
    assert "a"
           ~>> string(empty: true)
           ~> [%Machete.Mismatch{message: "\"a\" is not empty", path: []}]
  end

  test "produces a useful mismatch for empty false" do
    assert ""
           ~>> string(empty: false)
           ~> [%Machete.Mismatch{message: "\"\" is empty", path: []}]
  end
end
