defmodule DateTimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches datetimes" do
    assert DateTime.utc_now() ~> datetime()
  end

  test "matches on precision match" do
    assert DateTime.utc_now() ~> datetime(precision: 6)
  end

  test "refutes on precision mismatch" do
    refute DateTime.utc_now() ~> datetime(precision: 0)
  end
end
