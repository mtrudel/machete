defmodule StringMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

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
    assert 1 ~>> string() ~> mismatch("1 is not a string")
  end

  test "produces a useful mismatch for exact length mismatches" do
    assert "a" ~>> string(length: 5) ~> mismatch("\"a\" is not exactly 5 characters")
  end

  test "produces a useful mismatch for min length mismatches" do
    assert "a" ~>> string(min: 5) ~> mismatch("\"a\" is less than 5 characters")
  end

  test "produces a useful mismatch for max length mismatches" do
    assert "abcdef" ~>> string(max: 5) ~> mismatch("\"abcdef\" is more than 5 characters")
  end

  test "produces a useful mismatch for empty true" do
    assert "a" ~>> string(empty: true) ~> mismatch("\"a\" is not empty")
  end

  test "produces a useful mismatch for empty false" do
    assert "" ~>> string(empty: false) ~> mismatch("\"\" is empty")
  end
end
