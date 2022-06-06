defmodule NaiveDateTimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches naive datetimes" do
    assert NaiveDateTime.utc_now() ~> naive_datetime()
  end

  test "matches on precision match" do
    assert NaiveDateTime.utc_now() ~> naive_datetime(precision: 6)
  end

  test "produces a useful mismatch for non NaiveDateTimes" do
    assert 1
           ~>> naive_datetime()
           ~> [
             %ExMatchers.Mismatch{
               message: "1 is not a NaiveDateTime",
               path: []
             }
           ]
  end

  test "produces a useful mismatch for precision mismatches" do
    assert NaiveDateTime.utc_now()
           ~>> naive_datetime(precision: 0)
           ~> [
             %ExMatchers.Mismatch{
               message: "Precision does not match",
               path: []
             }
           ]
  end
end
