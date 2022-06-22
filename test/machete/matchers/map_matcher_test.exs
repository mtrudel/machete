defmodule MapMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.MapMatcher

  test "produces a useful mismatch for map mismatches" do
    assert 123 ~>> map() ~> mismatch("123 is not a map")
  end

  test "produces a useful mismatch for key mismatches" do
    assert %{a: 1} ~>> map(keys: integer()) ~> mismatch(":a is not an integer", :a)
  end

  test "produces a useful mismatch for value mismatches" do
    assert %{a: 1} ~>> map(values: string()) ~> mismatch("1 is not a string", :a)
  end

  test "produces a useful mismatch for size mismatches" do
    assert %{a: 1} ~>> map(size: 2) ~> mismatch("%{a: 1} is not exactly 2 pairs in size")
  end

  test "produces a useful mismatch for min size mismatches" do
    assert %{a: 1} ~>> map(min: 2) ~> mismatch("%{a: 1} is less than 2 pairs in size")
  end

  test "produces a useful mismatch for max size mismatches" do
    assert %{a: 1, b: 1}
           ~>> map(max: 1)
           ~> mismatch("%{a: 1, b: 1} is greater than 1 pairs in size")
  end
end
