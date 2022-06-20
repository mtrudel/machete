defmodule ListOfMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  test "matches on type match" do
    assert [1] ~> list_of(integer())
  end

  test "matches on min length" do
    assert [1] ~> list_of(integer(), min: 1)
  end

  test "matches on max length" do
    assert [1] ~> list_of(integer(), max: 2)
  end

  test "matches on length" do
    assert [1] ~> list_of(integer(), length: 1)
  end

  test "produces a useful mismatch for type mismatches" do
    assert [1] ~>> list_of(string()) ~> mismatch("1 is not a string", "[0]")
  end

  test "produces a useful mismatch for min length mismatches" do
    assert [1] ~>> list_of(integer(), min: 2) ~> mismatch("[1] is less than 2 elements in length")
  end

  test "produces a useful mismatch for max length mismatches" do
    assert [1, 2]
           ~>> list_of(integer(), max: 1)
           ~> mismatch("[1, 2] is more than 1 elements in length")
  end

  test "produces a useful mismatch for length mismatches" do
    assert [1]
           ~>> list_of(integer(), length: 2)
           ~> mismatch("[1] is not exactly 2 elements in length")
  end

  test "produces a useful mismatch for when value is not a map" do
    assert 1 ~>> list_of(integer()) ~> mismatch("1 is not a list")
  end
end
