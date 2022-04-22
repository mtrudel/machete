defmodule BooleanMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches true" do
    assert true ~> ExMatchers.boolean()
  end

  test "matches false" do
    assert false ~> ExMatchers.boolean()
  end
end
