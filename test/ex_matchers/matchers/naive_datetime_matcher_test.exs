defmodule NaiveDateTimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  setup do
    {:ok, datetime: NaiveDateTime.utc_now()}
  end

  test "matches naive datetimes", context do
    assert context.datetime ~> naive_datetime()
  end

  test "matches on precision match", context do
    assert context.datetime ~> naive_datetime(precision: 6)
  end

  test "produces a useful mismatch for non NaiveDateTimes" do
    assert 1
           ~>> naive_datetime(precision: 6)
           ~> [%ExMatchers.Mismatch{message: "1 is not a NaiveDateTime", path: []}]
  end

  test "produces a useful mismatch for precision mismatches", context do
    assert context.datetime
           ~>> naive_datetime(precision: 0)
           ~> [
             %ExMatchers.Mismatch{
               message: "#{inspect(context.datetime)} has precision 6, expected 0",
               path: []
             }
           ]
  end
end
