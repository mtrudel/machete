defmodule LiteralTupleMatcherTest do
  use ExUnit.Case, async: true
  use ExMatchers

  test "matches empty tuple" do
    assert {} ~> {}
  end

  test "matches literal tuples" do
    assert {1} ~> {1}
  end

  test "produces a useful mismatch on missing entries" do
    assert {}
           ~>> {1}
           ~> [
             %ExMatchers.Mismatch{
               message: "Tuple sizes not equal",
               path: []
             }
           ]
  end

  test "produces a useful mismatch on extra entries" do
    assert {1}
           ~>> {}
           ~> [
             %ExMatchers.Mismatch{
               message: "Tuple sizes not equal",
               path: []
             }
           ]
  end

  test "produces a useful mismatch on non-tuples" do
    assert 1
           ~>> {}
           ~> [
             %ExMatchers.Mismatch{
               message: "1 is not a tuple",
               path: []
             }
           ]
  end

  describe "nested matchers" do
    test "matches based on nested matchers" do
      assert {1} ~> {integer()}
    end

    test "produces a useful mismatch on nested mismatches" do
      assert {1.0}
             ~>> {integer()}
             ~> [
               %ExMatchers.Mismatch{
                 message: "1.0 is not an integer",
                 path: ["{0}"]
               }
             ]
    end
  end
end
