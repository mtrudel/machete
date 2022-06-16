defmodule LiteralTupleMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import TestMatcher

  test "matches empty tuple" do
    assert {} ~> {}
  end

  test "matches literal tuples" do
    assert {1} ~> {1}
  end

  test "produces a useful mismatch on missing entries" do
    assert {} ~>> {1} ~> [%Machete.Mismatch{message: "Tuple sizes not equal", path: []}]
  end

  test "produces a useful mismatch on extra entries" do
    assert {1} ~>> {} ~> [%Machete.Mismatch{message: "Tuple sizes not equal", path: []}]
  end

  test "produces a useful mismatch on non-tuples" do
    assert 1 ~>> {} ~> [%Machete.Mismatch{message: "1 is not a tuple", path: []}]
  end

  describe "nested matchers" do
    test "matches when nested matcher returns empty list" do
      assert {1} ~>> {test_matcher(behaviour: :match_returning_list)} ~> []
    end

    test "matches when nested matcher returns nil" do
      assert {1} ~>> {test_matcher(behaviour: :match_returning_nil)} ~> []
    end

    test "produces a useful mismatch on nested mismatches" do
      assert {1}
             ~>> {test_matcher(behaviour: :always_mismatch)}
             ~> [%Machete.Mismatch{message: "Always mismatch", path: ["{0}"]}]
    end
  end
end
