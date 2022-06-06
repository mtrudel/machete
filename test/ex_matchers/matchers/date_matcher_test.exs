defmodule DateMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches dates" do
    assert Date.utc_today() ~> date()
  end

  test "produces a useful mismatch for non Dates" do
    assert 1
           ~>> date()
           ~> [
             %ExMatchers.Mismatch{
               message: "1 is not a Date",
               path: []
             }
           ]
  end
end
