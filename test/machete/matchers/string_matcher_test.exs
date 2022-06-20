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

  test "matches strings on match" do
    assert "abc" ~> string(matches: ~r/abc/)
  end

  test "matches strings on alphabetic true" do
    assert "abc" ~> string(alphabetic: true)
  end

  test "matches strings on alphabetic false" do
    assert "123" ~> string(alphabetic: false)
  end

  test "matches strings on lowercase true" do
    assert "abc" ~> string(lowercase: true)
  end

  test "matches strings on lowercase false" do
    assert "ABC" ~> string(lowercase: false)
  end

  test "matches strings on uppercase true" do
    assert "ABC" ~> string(uppercase: true)
  end

  test "matches strings on uppercase false" do
    assert "abc" ~> string(uppercase: false)
  end

  test "matches strings on alphanumeric true" do
    assert "abc123" ~> string(alphanumeric: true)
  end

  test "matches strings on alphanumeric false" do
    assert "$" ~> string(alphanumeric: false)
  end

  test "matches strings on numeric true" do
    assert "123" ~> string(numeric: true)
  end

  test "matches strings on numeric false" do
    assert "abc" ~> string(numeric: false)
  end

  test "matches strings on hexadecimal true" do
    assert "deadbeef0123" ~> string(hexadecimal: true)
  end

  test "matches strings on hexadecimal false" do
    assert "ghi" ~> string(hexadecimal: false)
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

  test "produces a useful mismatch for match" do
    assert "def" ~>> string(matches: ~r/abc/) ~> mismatch("\"def\" does not match ~r/abc/")
  end

  test "produces a useful mismatch for alphabetic true" do
    assert "123" ~>> string(alphabetic: true) ~> mismatch("\"123\" is not alphabetic")
  end

  test "produces a useful mismatch for alphabetic false" do
    assert "abc" ~>> string(alphabetic: false) ~> mismatch("\"abc\" is alphabetic")
  end

  test "produces a useful mismatch for uppercase true" do
    assert "abc" ~>> string(uppercase: true) ~> mismatch("\"abc\" is not uppercase")
  end

  test "produces a useful mismatch for uppercase false" do
    assert "ABC" ~>> string(uppercase: false) ~> mismatch("\"ABC\" is uppercase")
  end

  test "produces a useful mismatch for lowercase true" do
    assert "ABC" ~>> string(lowercase: true) ~> mismatch("\"ABC\" is not lowercase")
  end

  test "produces a useful mismatch for lowercase false" do
    assert "abc" ~>> string(lowercase: false) ~> mismatch("\"abc\" is lowercase")
  end

  test "produces a useful mismatch for alphanumeric true" do
    assert "$" ~>> string(alphanumeric: true) ~> mismatch("\"$\" is not alphanumeric")
  end

  test "produces a useful mismatch for alphanumeric false" do
    assert "abc123" ~>> string(alphanumeric: false) ~> mismatch("\"abc123\" is alphanumeric")
  end

  test "produces a useful mismatch for numeric true" do
    assert "abc" ~>> string(numeric: true) ~> mismatch("\"abc\" is not numeric")
  end

  test "produces a useful mismatch for numeric false" do
    assert "123" ~>> string(numeric: false) ~> mismatch("\"123\" is numeric")
  end

  test "produces a useful mismatch for hexadecimal true" do
    assert "ghi" ~>> string(hexadecimal: true) ~> mismatch("\"ghi\" is not hexadecimal")
  end

  test "produces a useful mismatch for hexadecimal false" do
    assert "deadbeef0123"
           ~>> string(hexadecimal: false)
           ~> mismatch("\"deadbeef0123\" is hexadecimal")
  end
end
