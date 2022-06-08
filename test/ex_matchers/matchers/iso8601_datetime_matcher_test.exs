defmodule ISO8601DateTimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches ISO8601 datetimes" do
    assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime()
  end

  test "matches on precision match" do
    assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(precision: 6)
  end

  test "matches on :utc time zone match" do
    assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(time_zone: :utc)
  end

  test "matches on time zone match" do
    assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(time_zone: "Etc/UTC")
  end

  test "matches on :now roughly match" do
    assert DateTime.utc_now() |> DateTime.to_iso8601() ~> iso8601_datetime(roughly: :now)
  end

  test "matches on roughly match" do
    assert "2020-01-01T00:00:00.000000Z"
           ~> iso8601_datetime(roughly: ~U[2020-01-01 00:00:05.000000Z])
  end

  test "matches on :now before match" do
    assert "2020-01-01T00:00:00.000000Z" ~> iso8601_datetime(before: :now)
  end

  test "matches on before match" do
    assert "2020-01-01T00:00:00.000000Z"
           ~> iso8601_datetime(before: ~U[3000-01-01 00:00:00.000000Z])
  end

  test "matches on :now after match" do
    assert "3000-01-01T00:00:00.000000Z" ~> iso8601_datetime(after: :now)
  end

  test "matches on after match" do
    assert "3000-01-01T00:00:00.000000Z"
           ~> iso8601_datetime(after: ~U[2020-01-01 00:00:00.000000Z])
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

  test "produces a useful mismatch for time zone mismatches" do
    assert "2020-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(time_zone: "America/Chicago")
           ~> [
             %ExMatchers.Mismatch{
               message:
                 "~U[2020-01-01 00:00:00.000000Z] has time zone Etc/UTC, expected America/Chicago",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert "2020-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(roughly: ~U[3000-01-01 00:00:00.000000Z])
           ~> [
             %ExMatchers.Mismatch{
               message:
                 "~U[2020-01-01 00:00:00.000000Z] is not within 10 seconds of ~U[3000-01-01 00:00:00.000000Z]",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for before mismatches" do
    assert "3000-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(before: ~U[2020-01-01 00:00:00.000000Z])
           ~> [
             %ExMatchers.Mismatch{
               message:
                 "~U[3000-01-01 00:00:00.000000Z] is not before ~U[2020-01-01 00:00:00.000000Z]",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for after mismatches" do
    assert "2020-01-01T00:00:00.000000Z"
           ~>> iso8601_datetime(after: ~U[3000-01-01 00:00:00.000000Z])
           ~> [
             %ExMatchers.Mismatch{
               message:
                 "~U[2020-01-01 00:00:00.000000Z] is not after ~U[3000-01-01 00:00:00.000000Z]",
               path: []
             }
           ]
  end
end
