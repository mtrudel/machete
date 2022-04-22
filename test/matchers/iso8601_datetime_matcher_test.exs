defmodule ISO8601DateTimeMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches ISO8601 datetimes" do
    assert "2020-01-01T00:00:00.000000Z" ~> ExMatchers.iso8601_datetime()
  end

  test "matches on precision match" do
    assert "2020-01-01T00:00:00.000000Z" ~> ExMatchers.iso8601_datetime(precision: 6)
  end

  test "refutes on precision mismatch" do
    refute "2020-01-01T00:00:00Z" ~> ExMatchers.iso8601_datetime(precision: 6)
  end
end
