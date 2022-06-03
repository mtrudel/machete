defmodule IntegerMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches integers" do
    assert 1 ~> integer()
  end
end
