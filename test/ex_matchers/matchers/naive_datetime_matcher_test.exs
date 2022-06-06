defmodule NaiveDateTimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches naive datetimes" do
    assert NaiveDateTime.utc_now() ~> naive_datetime()
  end

  test "matches on precision match" do
    assert NaiveDateTime.utc_now() ~> naive_datetime(precision: 6)
  end

  test "refutes on precision mismatch" do
    refute NaiveDateTime.utc_now() ~> naive_datetime(precision: 0)
  end
end
