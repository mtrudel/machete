defmodule LiteralMapMatcherTest do
  use ExUnit.Case, async: true

  import ExMatchers

  test "matches empty maps" do
    assert %{} ~> %{}
  end

  test "matches literal maps" do
    assert %{a: 1} ~> %{a: 1}
  end

  test "refutes based on missing entries" do
    refute %{} ~> %{a: 1}
  end

  test "refutes based on extra entries" do
    refute %{a: 1} ~> %{}
  end

  describe "nested matchers" do
    test "matches based on nested matchers" do
      assert %{a: 1} ~> %{a: ExMatchers.integer()}
    end

    test "refutes based on nested matchers" do
      refute %{a: 1.0} ~> %{a: ExMatchers.integer()}
    end
  end
end
