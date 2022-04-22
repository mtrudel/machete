defmodule FloatMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches floats" do
    assert 1.0 ~> ExMatchers.float()
  end
end
