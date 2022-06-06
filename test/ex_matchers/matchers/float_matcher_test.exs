defmodule FloatMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches floats" do
    assert 1.0 ~> float()
  end
end
