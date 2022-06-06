defmodule StringMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches strings" do
    assert "" ~> string()
  end

  test "produces a useful mismatch for non strings" do
    assert 1
           ~>> string()
           ~> [
             %ExMatchers.Mismatch{
               message: "1 is not a string",
               path: []
             }
           ]
  end
end
