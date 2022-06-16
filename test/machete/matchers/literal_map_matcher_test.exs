defmodule LiteralMapMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import TestMatcher

  test "matches empty maps" do
    assert %{} ~> %{}
  end

  test "matches literal maps" do
    assert %{a: 1} ~> %{a: 1}
  end

  test "produces a useful mismatch on missing entries" do
    assert %{} ~>> %{a: 1} ~> [%Machete.Mismatch{message: "Missing key", path: [:a]}]
  end

  test "produces a useful mismatch on extra entries" do
    assert %{a: 1} ~>> %{} ~> [%Machete.Mismatch{message: "Unexpected key", path: [:a]}]
  end

  test "produces a useful mismatch on non-maps" do
    assert 1 ~>> %{} ~> [%Machete.Mismatch{message: "1 is not a map", path: []}]
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
             ~> [%Machete.Mismatch{message: "Always mismatch", path: [:a]}]
    end
  end

  describe "struct matches" do
    defmodule TestStruct do
      defstruct a: nil
    end

    test "produces a useful mismatch against structs" do
      assert %TestStruct{a: 1}
             ~>> %{a: integer()}
             ~> [%Machete.Mismatch{message: "Can't match a map to a struct", path: []}]
    end
  end
end
