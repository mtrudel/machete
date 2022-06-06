defmodule DateTimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches datetimes" do
    assert DateTime.utc_now() ~> datetime()
  end

  test "matches on precision match" do
    assert DateTime.utc_now() ~> datetime(precision: 6)
  end

  test "produces a useful mismatch for non DateTimes" do
    assert 1 ~>> datetime() ~> [%ExMatchers.Mismatch{message: "1 is not a DateTime", path: []}]
  end

  test "produces a useful mismatch for precision mismatches" do
    assert DateTime.utc_now()
           ~>> datetime(precision: 0)
           ~> [%ExMatchers.Mismatch{message: "Precision does not match", path: []}]
  end
end
