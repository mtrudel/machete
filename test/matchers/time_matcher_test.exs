defmodule TimeMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches times" do
    assert Time.utc_now() ~> ExMatchers.time()
  end

  test "matches on precision match" do
    assert Time.utc_now() ~> ExMatchers.time(precision: 6)
  end

  test "refutes on precision mismatch" do
    refute Time.utc_now() ~> ExMatchers.time(precision: 0)
  end
end
