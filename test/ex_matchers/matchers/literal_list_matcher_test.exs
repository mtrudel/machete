defmodule LiteralListMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches empty list" do
    assert [] ~> []
  end

  test "matches literal lists" do
    assert [1] ~> [1]
  end

  test "produces a useful mismatch on missing entries" do
    assert []
           ~>> [1]
           ~> [
             %ExMatchers.Mismatch{
               message: "List lengths not equal",
               path: []
             }
           ]
  end

  test "produces a useful mismatch on extra entries" do
    assert [1]
           ~>> []
           ~> [
             %ExMatchers.Mismatch{
               message: "List lengths not equal",
               path: []
             }
           ]
  end

  test "produces a useful mismatch on non-lists" do
    assert 1
           ~>> []
           ~> [
             %ExMatchers.Mismatch{
               message: "1 is not a list",
               path: []
             }
           ]
  end

  # Non-list message

  describe "nested matchers" do
    test "matches based on nested matchers" do
      assert [1] ~> [integer()]
    end

    test "produces a useful mismatch on nested mismatches" do
      assert [1.0]
             ~>> [integer()]
             ~> [
               %ExMatchers.Mismatch{
                 message: "1.0 is not an integer",
                 path: ["[0]"]
               }
             ]
    end
  end
end
