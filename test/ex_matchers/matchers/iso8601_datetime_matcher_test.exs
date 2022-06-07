defmodule ISO8601DateTimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches ISO8601 datetimes" do
    assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime()
  end

  test "matches on precision match" do
    assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(precision: 6)
  end

  test "produces a useful mismatch for non strings" do
    assert 1
           ~>> iso8601_datetime()
           ~> [%ExMatchers.Mismatch{message: "1 is not a string", path: []}]
  end

  test "produces a useful mismatch for non-parseable strings" do
    assert "abc"
           ~>> iso8601_datetime()
           ~> [
             %ExMatchers.Mismatch{
               message: "\"abc\" is not a parseable ISO8601 datetime",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for precision mismatches" do
    assert "2020-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(precision: 0)
           ~> [
             %ExMatchers.Mismatch{
               message: "~U[2020-01-01 00:00:00.000000Z] has precision 6, expected 0",
               path: []
             }
           ]
  end
end
