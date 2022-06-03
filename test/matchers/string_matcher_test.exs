defmodule StringMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches strings" do
    assert "" ~> string()
  end
end
