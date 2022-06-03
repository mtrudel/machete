defmodule LiteralListMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches empty list" do
    assert [] ~> []
  end

  test "matches literal lists" do
    assert [1] ~> [1]
  end

  test "refutes based on missing entries" do
    refute [] ~> [1]
  end

  test "refutes based on extra entries" do
    refute [1] ~> []
  end

  describe "nested matchers" do
    test "matches based on nested matchers" do
      assert [1] ~> [integer()]
    end

    test "refutes based on nested matchers" do
      refute [1.0] ~> [integer()]
    end
  end
end
