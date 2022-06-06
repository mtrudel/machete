defmodule IntegerMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches integers" do
    assert 1 ~> integer()
  end

  test "produces a useful mismatch for non integers" do
    assert 1.0
           ~>> integer()
           ~> [
             %ExMatchers.Mismatch{
               message: "1.0 is not an integer",
               path: []
             }
           ]
  end
end
