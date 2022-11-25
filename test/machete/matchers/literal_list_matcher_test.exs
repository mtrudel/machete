defmodule LiteralListMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  import TestMatcher

  test "matches empty list" do
    assert [] ~> []
  end

  test "matches literal lists" do
    assert [1] ~> [1]
  end

  test "produces a useful mismatch on missing entries" do
    assert [] ~>> [1] ~> mismatch("List is 0 elements in length, expected 1")
  end

  test "produces a useful mismatch on extra entries" do
    assert [1] ~>> [] ~> mismatch("List is 1 elements in length, expected 0")
  end

  test "produces a useful mismatch on non-lists" do
    assert 1 ~>> [] ~> mismatch("Value is not a list")
  end

  describe "nested matchers" do
    test "matches when nested matcher returns empty list" do
      assert [1] ~>> [test_matcher(behaviour: :match_returning_list)] ~> []
    end

    test "matches when nested matcher returns nil" do
      assert [1] ~>> [test_matcher(behaviour: :match_returning_nil)] ~> []
    end

    test "produces a useful mismatch on nested mismatches" do
      assert [1]
             ~>> [test_matcher(behaviour: :always_mismatch)]
             ~> mismatch("Always mismatch", "[0]")
    end
  end
end
