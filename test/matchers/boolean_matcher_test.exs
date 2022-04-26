defmodule BooleanMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches true" do
    assert true ~> boolean()
  end

  test "matches false" do
    assert false ~> boolean()
  end
end
