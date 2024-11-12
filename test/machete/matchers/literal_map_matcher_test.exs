defmodule LiteralMapMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch
  import TestMatcher

  test "matches empty maps" do
    assert %{} ~> %{}
  end

  test "matches literal maps" do
    assert %{a: 1} ~> %{a: 1}
  end

  test "produces a useful mismatch on missing entries" do
    assert %{} ~>> %{a: 1} ~> mismatch("Missing key", :a)
  end

  test "produces a useful mismatch on extra entries" do
    assert %{a: 1} ~>> %{} ~> mismatch("Unexpected key", :a)
  end

  test "produces a useful mismatch on atom entries where strings were expected" do
    assert %{a: 1} ~>> %{"a" => 1} ~> mismatch("Found atom key, expected string", :a)
  end

  test "produces a useful mismatch on atom entries where atoms were expected" do
    assert %{"a" => 1} ~>> %{a: 1} ~> mismatch("Found string key, expected atom", "a")
  end

  test "produces a useful mismatch on non-maps" do
    assert 1 ~>> %{} ~> mismatch("Value is not a map")
  end

  describe "nested matchers" do
    test "matches when nested matcher returns empty list" do
      assert %{a: 1} ~>> %{a: test_matcher(behaviour: :match_returning_list)} ~> []
    end

    test "matches when nested matcher returns nil" do
      assert %{a: 1} ~>> %{a: test_matcher(behaviour: :match_returning_nil)} ~> []
    end

    test "produces a useful mismatch on nested mismatches" do
      assert %{a: 1}
             ~>> %{a: test_matcher(behaviour: :always_mismatch)}
             ~> mismatch("Always mismatch", :a)
    end
  end

  describe "struct matches" do
    defmodule TestStruct do
      defstruct a: nil
    end

    test "produces a useful mismatch against structs" do
      assert %TestStruct{a: 1} ~>> %{a: integer()} ~> mismatch("Can't match a map to a struct")
    end
  end
end
