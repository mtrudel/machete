defmodule AnyMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches anything" do
    assert "a" ~> any()
    assert :a ~> any()
    assert 1 ~> any()
    assert %{} ~> any()
    assert nil ~> any()
  end
end
