defmodule LiteralMapMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches empty maps" do
    assert %{} ~> %{}
  end

  test "matches literal maps" do
    assert %{a: 1} ~> %{a: 1}
  end

  test "produces a useful mismatch on missing entries" do
    assert %{}
           ~>> %{a: 1}
           ~> [
             %ExMatchers.Mismatch{
               message: "Missing key",
               path: [:a]
             }
           ]
  end

  test "produces a useful mismatch on extra entries" do
    assert %{a: 1}
           ~>> %{}
           ~> [
             %ExMatchers.Mismatch{
               message: "Unexpected key",
               path: [:a]
             }
           ]
  end

  test "produces a useful mismatch on non-maps" do
    assert 1
           ~>> %{}
           ~> [
             %ExMatchers.Mismatch{
               message: "1 is not a map",
               path: []
             }
           ]
  end

  describe "nested matchers" do
    test "matches based on nested matchers" do
      assert %{a: 1} ~> %{a: integer()}
    end

    test "produces a useful mismatch on nested mismatches" do
      assert %{a: 1.0}
             ~>> %{a: integer()}
             ~> [
               %ExMatchers.Mismatch{
                 message: "1.0 is not an integer",
                 path: [:a]
               }
             ]
    end
  end

  describe "struct matches" do
    defmodule TestStruct do
      defstruct a: nil
    end

    test "produces a useful mismatch against structs" do
      assert %TestStruct{a: 1}
             ~>> %{a: integer()}
             ~> [
               %ExMatchers.Mismatch{
                 message: "Can't match a map to a struct",
                 path: []
               }
             ]
    end
  end
end
