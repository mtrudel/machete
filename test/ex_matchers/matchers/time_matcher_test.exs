defmodule TimeMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches times" do
    assert Time.utc_now() ~> time()
  end

  test "matches on precision match" do
    assert Time.utc_now() ~> time(precision: 6)
  end

  test "produces a useful mismatch for non Times" do
    assert 1
           ~>> time(precision: 6)
           ~> [%ExMatchers.Mismatch{message: "1 is not a Time", path: []}]
  end

  test "produces a useful mismatch for precision mismatches" do
    assert Time.utc_now()
           ~>> time(precision: 0)
           ~> [%ExMatchers.Mismatch{message: "Precision does not match", path: []}]
  end
end
