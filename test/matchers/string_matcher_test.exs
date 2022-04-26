defmodule StringMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches strings" do
    assert "" ~> string()
  end
end
