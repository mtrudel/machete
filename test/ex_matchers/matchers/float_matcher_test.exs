defmodule FloatMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches floats" do
    assert 1.0 ~> float()
  end

  test "produces a useful mismatch for non floats" do
    assert 1 ~>> float() ~> [%ExMatchers.Mismatch{message: "1 is not a float", path: []}]
  end
end
