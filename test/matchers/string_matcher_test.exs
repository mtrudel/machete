defmodule StringMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches strings" do
    assert "" ~> ExMatchers.string()
  end
end
