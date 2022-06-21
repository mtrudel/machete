defmodule ISO8601DateTimeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.ISO8601DateTimeMatcher

  test "produces a useful mismatch for non strings" do
    assert 1 ~>> iso8601_datetime() ~> mismatch("1 is not a string")
  end

  test "produces a useful mismatch for non-parseable strings" do
    assert "abc" ~>> iso8601_datetime() ~> mismatch("\"abc\" is not a parseable ISO8601 datetime")
  end

  test "produces a useful mismatch for precision mismatches" do
    assert "2020-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(precision: 0)
           ~> mismatch("~U[2020-01-01 00:00:00.000000Z] has precision 6, expected 0")
  end

  test "produces a useful mismatch for time zone mismatches" do
    assert "2020-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(time_zone: "America/Chicago")
           ~> mismatch(
             "~U[2020-01-01 00:00:00.000000Z] has time zone Etc/UTC, expected America/Chicago"
           )
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert "2020-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(roughly: ~U[3000-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[2020-01-01 00:00:00.000000Z] is not within 10 seconds of ~U[3000-01-01 00:00:00.000000Z]"
           )
  end

  test "produces a useful mismatch for before mismatches" do
    assert "3000-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(before: ~U[2020-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[3000-01-01 00:00:00.000000Z] is not before ~U[2020-01-01 00:00:00.000000Z]"
           )
  end

  test "produces a useful mismatch for after mismatches" do
    assert "2020-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(after: ~U[3000-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[2020-01-01 00:00:00.000000Z] is not after ~U[3000-01-01 00:00:00.000000Z]"
           )
  end
end
