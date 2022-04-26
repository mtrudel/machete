defmodule AnyMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches anything" do
    assert "a" ~> ExMatchers.any()
    assert :a ~> ExMatchers.any()
    assert 1 ~> ExMatchers.any()
    assert %{} ~> ExMatchers.any()
    assert nil ~> ExMatchers.any()
  end
end
