defmodule NaiveDateTimeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.NaiveDateTimeMatcher

  setup do
    {:ok, datetime: NaiveDateTime.utc_now()}
  end

  test "produces a useful mismatch for non NaiveDateTimes" do
    assert 1 ~>> naive_datetime(precision: 6) ~> mismatch("1 is not a NaiveDateTime")
  end

  test "produces a useful mismatch for precision mismatches", context do
    assert context.datetime
           ~>> naive_datetime(precision: 0)
           ~> mismatch("#{inspect(context.datetime)} has precision 6, expected 0")
  end

  test "produces a useful mismatch for exactly mismatches" do
    assert ~N[2020-01-01 00:00:00.000000]
           ~>> naive_datetime(exactly: ~N[3000-01-01 00:00:00.000000])
           ~> mismatch(
             "~N[2020-01-01 00:00:00.000000] is not equal to ~N[3000-01-01 00:00:00.000000]"
           )
  end

  test "produces a useful mismatch for roughly mismatches" do
    assert ~N[2020-01-01 00:00:00.000000]
           ~>> naive_datetime(roughly: ~N[3000-01-01 00:00:00.000000])
           ~> mismatch(
             "~N[2020-01-01 00:00:00.000000] is not within 10 seconds of ~N[3000-01-01 00:00:00.000000]"
           )
  end

  test "produces a useful mismatch for before mismatches" do
    assert ~N[3000-01-01 00:00:00.000000]
           ~>> naive_datetime(before: ~N[2020-01-01 00:00:00.000000])
           ~> mismatch(
             "~N[3000-01-01 00:00:00.000000] is not before ~N[2020-01-01 00:00:00.000000]"
           )
  end

  test "produces a useful mismatch for after mismatches" do
    assert ~N[2020-01-01 00:00:00.000000]
           ~>> naive_datetime(after: ~N[3000-01-01 00:00:00.000000])
           ~> mismatch(
             "~N[2020-01-01 00:00:00.000000] is not after ~N[3000-01-01 00:00:00.000000]"
           )
  end
end
