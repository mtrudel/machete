defmodule ListMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.ListMatcher

  test "produces a useful mismatch for type mismatches" do
    assert [1] ~>> list(elements: string()) ~> mismatch("1 is not a string", "[0]")
  end

  test "produces a useful mismatch for length mismatches" do
    assert [1] ~>> list(length: 2) ~> mismatch("[1] is not exactly 2 elements in length")
  end

  test "produces a useful mismatch for min length mismatches" do
    assert [1] ~>> list(min: 2) ~> mismatch("[1] is less than 2 elements in length")
  end

  test "produces a useful mismatch for max length mismatches" do
    assert [1, 2] ~>> list(max: 1) ~> mismatch("[1, 2] is more than 1 elements in length")
  end

  test "produces a useful mismatch for when value is not a list" do
    assert 1 ~>> list() ~> mismatch("1 is not a list")
  end
end
