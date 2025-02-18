defmodule DateTimeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.DateTimeMatcher

  setup do
    {:ok, datetime: DateTime.utc_now()}
  end

  test "produces a useful mismatch for non DateTimes" do
    assert 1
           ~>> datetime(precision: 6)
           ~> mismatch("1 is not a DateTime")
  end

  test "produces a useful mismatch for precision mismatches", context do
    assert context.datetime
           ~>> datetime(precision: 0)
           ~> mismatch("#{inspect(context.datetime)} has precision 6, expected 0")
  end

  test "produces a useful mismatch for time zone mismatches", context do
    assert context.datetime
           ~>> datetime(time_zone: "America/Chicago")
           ~> mismatch(
             "#{inspect(context.datetime)} has time zone Etc/UTC, expected America/Chicago"
           )
  end

  test "produces a useful mismatch for exactly mismatches" do
    assert ~U[2020-01-01 00:00:00.000000Z]
           ~>> datetime(exactly: ~U[3000-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[2020-01-01 00:00:00.000000Z] is not equal to ~U[3000-01-01 00:00:00.000000Z]"
           )
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert ~U[2020-01-01 00:00:00.000000Z]
           ~>> datetime(roughly: ~U[3000-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[2020-01-01 00:00:00.000000Z] is not roughly equal to ~U[3000-01-01 00:00:00.000000Z]"
           )
  end

  test "produces a useful mismatch for before mismatches" do
    assert ~U[3000-01-01 00:00:00.000000Z]
           ~>> datetime(before: ~U[2020-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[3000-01-01 00:00:00.000000Z] is not before ~U[2020-01-01 00:00:00.000000Z]"
           )
  end

  test "produces a useful mismatch for after mismatches" do
    assert ~U[2020-01-01 00:00:00.000000Z]
           ~>> datetime(after: ~U[3000-01-01 00:00:00.000000Z])
           ~> mismatch(
             "~U[2020-01-01 00:00:00.000000Z] is not after ~U[3000-01-01 00:00:00.000000Z]"
           )
  end
end
